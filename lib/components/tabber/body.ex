defmodule EasyPage.Components.Tabber.Body do
  @moduledoc ~s"""
  A component which takes :tab slots.
  Renders whichever :tab slot is currently selected, based on title.

  Titles must be unique.

  > #### Warning {: .warning}
  > 
  > Most of Tabber's magic is in the backend, not the components.
  > You are probably better off copying the source code so you can customize it for your app.

  ```elixir
  def render(assigns) do
    ~H\"\"\"
    <EasyPage.Components.Tabber.Body.body tabber={@tabber}>

      <:tab title="Tab A">
        <TabA.render whatever_assigns={1234} />
      </:tab>

      <:tab title="Tab B">
        <TabB.render other_assigns={1234} />
      </:tab>

      <:tab title="Tab C">
        <p>Meow</p>
      </:tab>


    </EasyPage.Components.Tabber.Body.body>
    \"\"\"
  end
  ```
  """
  use Phoenix.Component

  attr(:tabber, :map, required: true)

  slot :tab, doc: "The body of a tab." do
    attr(:title, :string, required: true)
  end

  def body(assigns) do
    ~H"""
    <%= if !!@tabber.ctl.current_tab do %>
      <div class="tabber_body__outer">
        <%= for %{title: title} = tab <- @tab do %>
          <div class="tabber_body__inner" :if={title == @tabber.ctl.current_tab.title}>
            {render_slot(tab)}
          </div>
        <% end %>
      </div>
    <% end %>
    """
  end
end
