defmodule ChatBubblesWeb.BubbleLive do
  alias ChatBubblesWeb.UserManager
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
    ChatBubblesWeb.Presence.track(self(), topic, user.id, %{username: user.username})
    socket = socket |> assign(
      meta_data: %{
        bubble: %{
          name: bubble_name
        }
      },
      user: user
    )
    {:ok, socket}
  end

  def socket_not_connected(param, _session, socket) do
    bubble_name = Map.get(param, "id")
    IO.inspect("++++++++++++")
    IO.inspect(bubble_name)
    socket = socket |> assign(
      meta_data: %{
        bubble: %{
          name: bubble_name
        }
      }
    )
    {:ok, socket}
  end

  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    IO.inspect("-=-=-=-=-=-=-=-=")
    IO.inspect(joins)
    IO.inspect(leaves)
    {:noreply, socket}
  end

end
