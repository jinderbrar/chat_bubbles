defmodule ChatBubblesWeb.User do
  defstruct username: "Guest", id: -1
end

defmodule ChatBubblesWeb.UserManager do
  alias ChatBubblesWeb.User

  def create_new_user do
    %User{
      id: to_string(:os.system_time(:nano_seconds)),
      username: MnemonicSlugs.generate_slug(2)
    }
  end
end
