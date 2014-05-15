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
      flash[:success] = I18n.t("mercator.messages.order.archive.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_place
    do_transition_action :place do
      flash[:success] = I18n.t("mercator.messages.order.place.success")
      flash[:notice] = nil

      Order.create(user: current_user) # and an new basket ...

      render action: :confirm
    end
  end

  def show
    @current_gtc = Gtc.order(version_of: :desc).first
    hobo_show do
      @current_user = current_user
      @current_user.confirmation = false
    end
  end
end