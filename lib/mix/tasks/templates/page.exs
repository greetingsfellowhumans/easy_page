defmodule MyAppWeb.Page do
  use MyAppWeb, :html

  def mount(_, _, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <p>Rendering page</p>
    """
  end
end
