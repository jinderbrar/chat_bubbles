defmodule ChatBubblesWeb.ChatManager do

  @longtime_format "%Y-%m-%d %I:%M:%S %p"
  @shorttime_format "%I:%M %p"

  defmodule ChatMessage do
    defstruct id: "", content: "", meta_data: %{}
  end
  def create_message(content, from \\ :system, type \\ :system) do
    dt_time = DateTime.utc_now()
    timestamp = dt_time |> DateTime.to_unix(:microsecond)
    # unique integer for current runtime
    unq = System.unique_integer([:positive])
    message_id = "msg_#{from}_#{type}_#{timestamp}_#{unq}"
    %ChatMessage{
      id: message_id,
      content: content,
      meta_data: %{
        from: from,
        type: type,
        timestamp: timestamp,
        time_long: dt_time |> Calendar.strftime(@longtime_format),
        time_short: dt_time |> Calendar.strftime(@shorttime_format)
      }
    }
  end


  def create_user_join_message(user) do
    content = "#{user.username} joined chat."
    create_message(content)
  end

  def create_user_left_message(user) do
    content = "#{user.username} left chat."
    create_message(content)
  end

end
