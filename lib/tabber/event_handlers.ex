defmodule EasyPage.Tabber.EventHandlers do
  @moduledoc false
  use Phoenix.LiveComponent

  def handle_event("tabber_click_" <> idxstr, _params, socket) do
    idx = String.to_integer(idxstr)
    socket = EasyPage.Tabber.click_tab(socket, idx)
    {:noreply, socket}
  end
end
