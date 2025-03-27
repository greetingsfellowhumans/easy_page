defmodule EasyPage.Tabber.Tab do
  @moduledoc """
  In order to gain the functionality of tab callbacks, you will need modules that implement the tab lifecycle functions.
  This may or may not be the Component module.

  ```elixir
  defmodule TabA do
    @behaviour EasyPage.Tabber.Tab

    @impl true
    def on_init(socket) do
      IO.puts "Initialized Tab A"
      socket
    end

    @impl true
    def on_first_enter(socket) do
      data = call_database()
      assign(socket, :data, data)
    end
  end
  ```
  """

  defstruct [
    :idx,
    :href,
    :method,
    :module,
    :phx_click,
    title: "",
    never_opened?: true
    # currently_open?: false
  ]

  @doc false
  def new({{title, options}, idx}) do
    m = Enum.into(options, %{title: title, idx: idx})
    struct(__MODULE__, m)
  end

  # def new({{title, [path: path, method: method]}, idx}) do
  #  struct(__MODULE__, %{idx: idx, title: title, href: path, method: method})
  # end

  # def new({{title, [phx_click: msg] = _tab}, idx}) do
  #  struct(__MODULE__, %{idx: idx, title: title, phx_click: msg})
  # end

  # def new({{title, path}, idx}) when is_binary(path) do
  #  struct(__MODULE__, %{idx: idx, title: title, href: path, method: "get"})
  # end

  # def new({{title, mod}, idx}) when is_atom(mod) do
  #  struct(__MODULE__, %{idx: idx, title: title, module: mod})
  # end

  # def new(body), do: struct(__MODULE__, body)

  @optional_callbacks [
    on_init: 1,
    on_enter: 1,
    on_first_enter: 1,
    on_not_first_enter: 1,
    on_exit: 1
  ]

  @doc """
  Called for all tabs during Mount
  """
  @callback on_init(%Phoenix.LiveView.Socket{}) :: %Phoenix.LiveView.Socket{}

  @doc """
  Called EVERY time a tab is selected
  """
  @callback on_enter(%Phoenix.LiveView.Socket{}) :: %Phoenix.LiveView.Socket{}

  @doc """
  Called ONLY the first time a tab is selected
  """
  @callback on_first_enter(%Phoenix.LiveView.Socket{}) :: %Phoenix.LiveView.Socket{}

  @doc """
  Called every time a tab is selected, except the first time
  """
  @callback on_not_first_enter(%Phoenix.LiveView.Socket{}) :: %Phoenix.LiveView.Socket{}

  @doc """
  Called when the tab is unselected.
  """
  @callback on_exit(%Phoenix.LiveView.Socket{}) :: %Phoenix.LiveView.Socket{}

  defp safe_apply(tab, socket, fn_name) do
    if Kernel.function_exported?(tab, fn_name, 1) do
      apply(tab, fn_name, [socket])
    else
      socket
    end
  end

  @doc false
  def on_init(tab, socket), do: safe_apply(tab, socket, :on_init)

  @doc false
  def on_enter(tab, socket), do: safe_apply(tab, socket, :on_enter)

  @doc false
  def on_first_enter(tab, socket), do: safe_apply(tab, socket, :on_first_enter)

  @doc false
  def on_not_first_enter(tab, socket), do: safe_apply(tab, socket, :on_not_first_enter)

  @doc false
  def on_exit(tab, socket), do: safe_apply(tab, socket, :on_exit)
end
