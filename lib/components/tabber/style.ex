defmodule EasyPage.Components.Tabber.Style do
  @moduledoc false
  use Phoenix.Component

  def style(assigns) do
    ~H"""
    <style>
      /*
      This is just a quick and dirty solution for demo purposes. You should write your own styles, or even component, to customize it for your own app.
      */
      .tabber_menu__button {
        background: antiquewhite;
        min-width: 2rem;
        padding: 0.5rem 1rem;
      }
      .tabber_menu__button:hover {
        background: chocolate;
      }
      .tabber_menu__button.selected {
        border: solid 1px;
      }
      .tabber_body__outer {
        border: solid 1px;
      }
    </style>
    """
  end
end
