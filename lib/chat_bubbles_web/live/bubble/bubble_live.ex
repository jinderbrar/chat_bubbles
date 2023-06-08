defmodule ChatBubblesWeb.BubbleLive do
  alias ChatBubblesWeb.UserManager
  alias ChatBubblesWeb.ChatManager
  use ChatBubblesWeb, :live_view

  @impl true
  def mount(param, session, socket) do

    if connected?(socket) do
      socket_connected(param, session, socket)
    else
      socket_not_connected(param, session, socket)
    end
  end


  @impl true
  def socket_connected(param, _session, socket) do
    bubble_name = Map.get(param, "id")
    topic = "topic:" <> bubble_name

    user = UserManager.create_new_user()

    ChatBubblesWeb.Endpoint.subscribe(topic)
    ChatBubblesWeb.Presence.track(self(), topic, user.id, %{user: user})

    welcome_msg = ChatManager.create_user_join_message(user)

    # ChatBubblesWeb.Endpoint.broadcast(topic, "broadcasted_messages", %{messages: [welcome_msg]})
    socket = socket |> assign(
      meta_data: %{
        connected: true,
        bubble: %{
          name: bubble_name
        },
        user: user
      },
      message: ""
    ) |> stream(:chat_messages, [])
    {:ok, socket}
  end

  def socket_not_connected(param, _session, socket) do
    bubble_name = Map.get(param, "id")
    socket = socket |> assign(
      meta_data: %{
        connected: false,
        bubble: %{
          name: bubble_name
        }
      },
      message: ""
    )
    {:ok, socket}
  end

  def insert_many_msgs(socket, name, items, opts \\ []) do
    Enum.reduce(items, socket, fn item, acc ->
      Phoenix.LiveView.stream_insert(acc, name, item, opts)
    end)
  end
  @impl true
  def handle_info(%{event: "broadcasted_messages", payload: %{messages: messages}}, socket) do
    if length(messages) == 0 do
      {:noreply, socket}
    else
      msg = Enum.at(messages, 0)
      {:noreply, socket |> stream_insert(:chat_messages, msg)}
    end
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    user_left_msgs = leaves |> Enum.map(
      fn {_, val} ->
        val.metas |> Enum.at(0) |> Map.get(:user) |> ChatManager.create_user_left_message()
      end
    )
    all_msgs = user_left_msgs

    topic = "topic:" <> socket.assigns.meta_data.bubble.name
    ChatBubblesWeb.Endpoint.broadcast_from(self(), topic, "broadcasted_messages", %{messages: all_msgs})
    {:noreply, socket}
  end

  @impl true
  def handle_event("send_message", param = %{ "user_message" => user_message}, socket) do
    if String.length(user_message) > 0 do
      msg = ChatManager.create_message(user_message, socket.assigns.meta_data.user.username, :user)
      topic = "topic:" <> socket.assigns.meta_data.bubble.name
      ChatBubblesWeb.Endpoint.broadcast(topic, "broadcasted_messages", %{messages: [msg]})
    end
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_event("form_update", param = %{"user_message" => user_message}, socket) do
    {:noreply, assign(socket, message: user_message)}
  end

end
