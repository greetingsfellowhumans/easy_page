defmodule DemoWeb.Pages.Index.Mount do
  def mount(_, _, socket) do
    socket =
      socket
      |> EasyPage.Tabber.init_tabs(
        [
          {"Tab A", module: EasyPage.Tabber.NoopTab},
          {"Tab B", module: EasyPage.Tabber.NoopTab},
          {"Tab C", module: EasyPage.Tabber.NoopTab}
        ],
        default: "Tab A"
      )
    {:ok, socket}
  end

end

