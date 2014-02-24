class OrdersController < ApplicationController

  hobo_model_controller
  auto_actions_for :user, :index
  auto_actions :show, :lifecycle

  def refresh
    self.this = Order.find(params[:id])
    hobo_show
  end

  def do_archive_parked_basket
    do_transition_action :archive_parked_basket do
      flash[:success] = "Der geparkte Warenkorb wurde archiviert."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_place
    do_transition_action :place do
      flash[:success] = "Ihre Bestellung wurde angenommen."
      flash[:notice] = nil

      Order.create(user: current_user) # and an new basket ...

      render action: :confirm
    end
  end
end