class LineitemsController < ApplicationController

  hobo_model_controller
  auto_actions :destroy, :lifecycle

  def do_delete_from_basket
    do_transition_action :delete_from_basket do
      flash[:success] = "Die Bestellposition wurde gelöscht."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_add_one
    do_transition_action :add_one do
      flash[:success] = "Die Stückzahl wurde um 1 erhöht."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_remove_one
    do_transition_action :remove_one do
      flash[:success] = "Die Stückzahl wurde um 1 erniedrigt."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end
end