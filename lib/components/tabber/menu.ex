defmodule EasyPage.Components.Tabber.Menu do
  @moduledoc false
  use Phoenix.Component

  attr(:tabber, :map)

  def menu(assigns) do
    ~H"""
      <div class="tabber_menu__outer" :for={%{title: title, idx: idx} <- @tabber.tabs}>
        <button 
          class={"tabber_menu__button #{if @tabber.ctl.current_tab.idx == idx, do: "selected"}"} 
          phx-click={"tabber_click_#{idx}"}>
          <%= title %><%= if @tabber.ctl.current_tab.idx == idx, do: "*" %>
        </button>
      </div>
    """
  end
end
