defmodule EasyPage.Tabber.NoopTab do
  @moduledoc """
  Use this as the tab module when you don't actually need to use any of the lifecycle functions.
  """

  @behaviour EasyPage.Tabber.Tab

  @impl true
  def on_init(socket), do: socket
  @impl true
  def on_first_enter(socket), do: socket
  @impl true
  def on_enter(socket), do: socket
  @impl true
  def on_not_first_enter(socket), do: socket
  @impl true
  def on_exit(socket), do: socket
end
