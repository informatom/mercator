class OrdersController < ApplicationController
  before_filter :domain_shop_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions_for :user, :index
  auto_actions :show, :lifecycle


  # from mercator/vendor/engines/mercator_mpay24/app/controllers/orders_controller_extensions.rb
  if Rails.application.config.try(:payment) == "mpay24"
    include OrdersControllerExtensions
  end


  def show
    @current_gtc = Gtc.order(version_of: :desc).first
    @parked_basket = current_user.parked_basket
    hobo_show do
      @current_user = current_user
      @current_user.confirmation = false
    end
  end


  show_action :refresh do
    self.this = @order = Order.find(params[:id])
    show_response
  end


  show_action :payment_status do
    @order = self.this = Order.find(params[:id])
    render :confirm
  end


  def do_archive_parked_basket
    do_transition_action :archive_parked_basket do
      flash[:success] = I18n.t("mercator.messages.order.archive.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end


  def do_place
    self.this = @order = Order.find(params[:id])

    if Rails.application.config.try(:erp) == "mesonic" && Rails.env == "production"
      # A quick check, if erp_account_number is current
      # (User could have been changed since last job run)
      current_user.update_erp_account_nr()

      unless @order.push_to_mesonic()
        flash[:error] = I18n.t "mercator.messages.order.place.failure"
        flash[:notice] = nil

        render action: :error and return
      end
    end

    do_transition_action :place do
      flash[:success] = I18n.t "mercator.messages.order.place.success"
      flash[:notice] = nil
      render action: :confirm
    end
  end


  def do_pay
    self.this = @order = Order.find(params[:id])

    if Rails.application.config.try(:payment) == "mpay24" &&
       ["production", "staging", "development"].include?(Rails.env.to_s)

      response = @order.pay(system: Rails.env.to_s)
    end

    do_transition_action :pay do
      Order.create(user: current_user) # and create a new basket ...

      if response.body[:select_payment_response][:location]
        redirect_to response.body[:select_payment_response][:location]
      else
        puts "Error:" + response.body[:select_payment_response][:err_text]
        flash[:error] = response.body[:select_payment_response][:err_text]
        flash[:notice] = nil
        render action: :show and return
      end
    end
  end
end