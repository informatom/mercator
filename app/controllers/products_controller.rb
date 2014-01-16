class ProductsController < ApplicationController

  hobo_model_controller
  auto_actions :show, :lifecycle

  def do_add_to_basket
    do_transition_action :add_to_basket do
      flash[:success] = "Das Produkt wurde zum Warenkorb hinzugefügt."
      flash[:notice] = nil
      redirect_to @product
    end
  end
end