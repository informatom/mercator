class OrdersController < ApplicationController

  before_filter :domain_shop_redirect

  hobo_model_controller
  auto_actions_for :user, :index
  auto_actions :show, :lifecycle

  # can be found in mercator/vendor/engines/mercator_mpay24/app/controllers/orders_controller_extensions.rb
  include OrdersControllerExtensions if Rails.application.config.try(:payment) == "mpay24"


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
    self.this = Order.find(params[:id])

    if Rails.application.config.try(:erp) == "mesonic" && Rails.env == "production"
      # A quick ckeck, if erp_account_number is current (User could have been changed since last job run)
      current_user.update_erp_account_nr()

      if self.this.push_to_mesonic()
        payment if Rails.application.config.try(:payment) == "mpay24"

        do_transition_action :place do
          flash[:success] = I18n.t("mercator.messages.order.place.success")
          flash[:notice] = nil

          Order.create(user: current_user) # and create a new basket ...
          render action: :confirm
        end

      else
        flash[:error] = I18n.t("mercator.messages.order.place.failure")
        flash[:notice] = nil
        render action: :error
      end
    else
      do_transition_action :place do
        flash[:success] = I18n.t("mercator.messages.order.place.success")
        flash[:notice] = nil

        Order.create(user: current_user) # and create a new basket ...
        render action: :confirm
      end
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