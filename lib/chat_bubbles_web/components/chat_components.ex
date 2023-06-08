defmodule ChatBubblesWeb.ChatComponents do
  use Phoenix.Component

  attr :msg, :any, required: true
  attr :id, :string, required: true
  attr :user, :any, required: true
  def user_message_chatbubble(assigns) do
    is_system_msg = assigns.msg.meta_data.type == :system
    is_user_msg = !is_system_msg
    from_curr_user = if assigns.msg.meta_data.from == assigns.user.username, do: true, else: false

    ~H"""
      <div :if={is_system_msg} id={"#{assigns.msg.id}"} class="mt-2 flex justify-center">
        <div class="text-center">
          <i> <%= @msg.content %> </i>
        </div>
      </div>

      <div :if={is_user_msg && from_curr_user} id={"#{assigns.msg.id}"} class={"flex flex-row justify-end"}>
        <div class={"flex flex-row-reverse gap-4"}>
          <div class="chat-image ">
            <div class="w-10 rounded-full">
              <img src={"https://api.multiavatar.com/#{@msg.meta_data.from}.svg"} />
            </div>
          </div>
          <div class={"chat chat-end grid-cols-1"}>
            <div class="chat-header">
              <%= @msg.meta_data.from %>
            </div>
            <div class="chat-bubble">
              <%= @msg.content %>
            </div>
            <div class="chat-footer">
              <time class="text-xs opacity-50">
                <%= @msg.meta_data.time_short %>
              </time>
            </div>
          </div>
        </div>
      </div>


      <div :if={is_user_msg && !from_curr_user} id={"#{assigns.msg.id}"}>
        <div class={"flex flex-row gap-2"}>
          <div class="chat-image ">
            <div class="w-10 rounded-full">
              <img src={"https://api.multiavatar.com/#{@msg.meta_data.from}.svg"} />
            </div>
          </div>
          <div class={"chat chat-start grid-cols-1"}>
            <div class="chat-header">
              <%= @msg.meta_data.from %>
            </div>
            <div class="chat-bubble">
              <%= @msg.content %>
            </div>
            <div class="chat-footer">
              <time class="text-xs opacity-50">
                <%= @msg.meta_data.time_short %>
              </time>
            </div>
          </div>
        </div>
      </div>
    """
  end



end
