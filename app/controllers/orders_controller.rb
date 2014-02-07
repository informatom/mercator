class OrdersController < ApplicationController

  hobo_model_controller
  auto_actions :index, :show, :lifecycle

    def do_archive_parked_basket
    do_transition_action :archive_parked_basket do
      flash[:success] = "Der geparkte Warenkorb wurde archiviert."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end
end