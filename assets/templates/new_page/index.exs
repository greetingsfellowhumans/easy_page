defmodule DemoWeb.Pages.Index do
  use DemoWeb, :live_view
  alias __MODULE__, as: Page
  alias EasyPage.Components.Tabber

  defdelegate mount(session, params, socket), to: Page.Mount
  defdelegate handle_event(msg, params, socket), to: Page.Handlers

  def render(assigns) do
    ~H"""
    <h1>Loading index page</h1>
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
    """
  end
end
