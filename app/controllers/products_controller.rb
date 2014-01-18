class ProductsController < ApplicationController

  hobo_model_controller
  auto_actions :show, :lifecycle

  def do_add_to_basket
    do_transition_action :add_to_basket do
      flash[:success] = "Das Produkt wurde zum Warenkorb hinzugefügt."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_compare
    do_transition_action :compare do
      session[:compared] << this.id
      flash[:success] = "Das Produkt wurde zur Vergleichsliste hinzugefügt."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_dont_compare
    do_transition_action :dont_compare do
      session[:compared].delete(this.id)
      flash[:success] = "Das Produkt wurde aus der Vergleichsliste entfernt."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end
end