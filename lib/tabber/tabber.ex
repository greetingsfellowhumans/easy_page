defmodule EasyPage.Tabber do
  @moduledoc ~s"""
  A server side tabination component with lifecycle hooks.
  You probably do NOT need this, as most use-cases for tabs would be better off with a client-side javascript solution.

  One possible use case for tabber is when you want to lazily load data.
  I.e., call the database on the first time you enter a tab.

  # Usage

  ```elixir
  # Now we create a tab component. 
  defmodule TabA do
    @behaviour EasyPage.Tabber.Tab
   
    # All tab callbacks are optional.
    # They each take a socket, and return a socket
    @impl true
    def on_first_enter(socket) do
      dbg "some setup stuff"
      socket
    end

  end

  # And to tie it all together, you must:
  # 1. Initialize it in your liveview,
  # 2. Call the Tabber.Body.body/1 component, and pass each tab into it as a slot.
  defmodule MyAppWeb.Parent do
    use MyAppWeb, :live_view
    alias EasyPage.Components.Tabber

    def mount(_, _, socket) do
      socket = Tabber.init_tabs(socket, [ 
        {"Tab A", TabA}, # <- Each title must be unique
        {"Tab B", TabB}, # But the module need not.
        {"Tab C", TabC} 
    ], default: "Tab A")
      {:ok, socket}
    end


    # Let tabber handle it's own events.
    @impl true
    def handle_event("tabber_" <> _ = evt, params, socket) do
      EasyPage.Tabber.EventHandlers.handle_event(evt, params, socket)
    end

    def render(assigns) do
      ~H\"\"\"
      <Tabber.Style.style />
      <Tabber.Menu.menu tabber={@tabber} />

      <Tabber.Body.body tabber={@tabber}>
        <:tab title="Tab A">
          <p>Rendering Tab A</p>
        </:tab>

        <:tab title="Tab B">
          <p>Rendering Tab B</p>
        </:tab>

        <:tab title="Tab C">
          <p>Rendering Tab C</p>
        </:tab>

      </Tabber.Body.body>
      \"\"\"
    end
  end
  ```

  To learn more about Tab modules, look at `EasyPage.Tabber.Tab`
  """
  alias EasyPage.Tabber.{Assigns, Tab}

  @doc ~s"""
  Use this to ensure a specific tab is open upon render. 

  ```elixir
  def mount(_, _, socket) do
    socket = EasyPage.Tabber.init_tabs(socket, [
      {"My Tab", module: SomeTab},
      {"Another Tab", module: AnotherTab},
    ])
    {:ok, socket}
  end
  ```

  ## Options
  `default (string | nil)`

  This must match one of the tab titles

  """
  def init_tabs(socket, tab_tups, opts \\ []) do
    tabs =
      tab_tups
      |> Enum.with_index()
      |> Enum.map(&Tab.new/1)

    tabber_assigns = Assigns.new(%{tabs: tabs}, opts)

    socket = Phoenix.Component.assign(socket, :tabber, tabber_assigns)

    socket =
      Enum.reduce(tabs, socket, fn tab, socket ->
        Code.ensure_loaded(tab.module)
        Tab.on_init(tab.module, socket)
      end)

    click_default(socket, opts)
  end

  defp click_default(socket, opts) do
    with title when is_binary(title) <- Keyword.get(opts, :default),
         tab when is_map(tab) <-
           Enum.find(socket.assigns.tabber.tabs, fn %{title: t} -> t == title end),
         idx when is_integer(idx) <- Map.get(tab, :idx) do
      click_tab(socket, idx)
    else
      _ -> socket
    end
  end

  @doc ~s"""
  Change the current tab, calling all appropriate callback functions as needed.
  Takes either the title, or idx of a tab.

  Keep in mind, you probably never need to use this function directly, it is called automatically via "tabber_" events.

  ```elixir
  def handle_event("click", %{"tab" => tab}, socket) do
    socket = EasyPage.Tabber.click_tab(socket, tab.idx)
    {:noreply, socket}
  end
  ```
  """
  def click_tab(socket, idx) when is_integer(idx) do
    socket = exit_tab(socket, idx)
    tab = get_tab(socket, idx)
    socket = enter_tab(socket, tab)
    Assigns.put_ctl(socket, :current_tab, tab)
  end

  def click_tab(socket, title) when is_binary(title) do
    idx =
      Enum.find_value(socket.assigns.tabber.tab, fn %{title: t, idx: idx} ->
        if t == title, do: idx, else: nil
      end)

    click_tab(socket, idx)
  end

  defp get_tab(socket, idx), do: Enum.at(socket.assigns.tabber.tabs, idx)

  defp exit_tab(socket, next_idx) do
    prev_tab = socket.assigns.tabber.ctl.current_tab

    if is_integer(prev_tab.idx) and prev_tab.idx != next_idx do
      Tab.on_exit(prev_tab.module, socket)
    else
      socket
    end
  end

  defp enter_tab(socket, tab) do
    socket =
      if tab.never_opened? do
        Tab.on_first_enter(tab.module, socket)
      else
        Tab.on_not_first_enter(tab.module, socket)
      end

    socket = put_has_been_entered(socket, tab)

    if socket.assigns.tabber.ctl.current_tab.idx != tab.idx do
      Tab.on_enter(tab.module, socket)
    else
      socket
    end
  end

  defp put_has_been_entered(socket, tab) do
    Assigns.update_tab(socket, tab.idx, fn tab ->
      Map.put(tab, :never_opened?, false)
    end)
  end
end
