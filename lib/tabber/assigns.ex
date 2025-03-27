defmodule EasyPage.Tabber.Assigns do
  @moduledoc false
  defstruct tabs: [],
            ctl: %{}

  @empty_tab %{idx: nil, title: nil}

  def new(%{tabs: tabs}, _opts) do
    default_tab = @empty_tab
    #  if title = Keyword.get(opts, :default) do
    #    Enum.find(tabs, fn %{title: t} -> t == title end) || @empty_tab
    #  else
    #    @empty_tab
    #  end

    body = %{
      tabs: tabs,
      ctl: %{current_tab: default_tab}
    }

    struct!(__MODULE__, body)
  end

  def update_tab(socket, idx, cb) do
    tabber = socket.assigns.tabber

    tabs =
      tabber.tabs
      |> List.update_at(idx, cb)

    tabber_assigns = Map.put(tabber, :tabs, tabs)

    socket
    |> Phoenix.Component.assign(:tabber, tabber_assigns)
  end

  def put_ctl(socket, k, v) do
    tabber = socket.assigns.tabber
    new_ctl = Map.put(tabber.ctl, k, v)
    tabber_assigns = Map.put(tabber, :ctl, new_ctl)

    socket
    |> Phoenix.Component.assign(:tabber, tabber_assigns)
  end
end
