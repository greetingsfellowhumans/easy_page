defmodule DemoWeb.Pages.Index.Handlers do
  
  def handle_event("tabber_" <> _ = msg, params, socket) do
    EasyPage.Tabber.EventHandlers.handle_event(msg, params, socket)
  end
  def handle_event(msg, _params, socket) do
    dbg("UNHANDLED EVENT #{msg}")
    {:noreply, socket}
  end

end


