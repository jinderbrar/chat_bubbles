defmodule ChatBubblesWeb.PageLive do
  use ChatBubblesWeb, :live_view

  embed_templates "page_live/"
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("create_bubble", _param, socket) do
    bubble_name = MnemonicSlugs.generate_slug(2)
    {:noreply, push_redirect(socket, to: "/#{bubble_name}")}
  end
end
