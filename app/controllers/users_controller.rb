class UsersController < ApplicationController
  after_filter :track_action

  hobo_user_controller
  auto_actions :all, :except => [ :index, :new, :create, :destroy ]
  auto_actions :lifecycle

  # can be found in mercator/vendor/engines/mercator_mesonic/app/controllers/users_controller_extensions.rb
  include UsersControllerExtensions if Rails.application.config.try(:erp) == "mesonic"

  autocomplete :surname


  def login
    unless session[:last_user]
      redirect_to "/switch" and return
    end

    if params[:fromfront] == "true"
      last_user_id = current_user.id
      logout()
    end

    hobo_login

    if logged_in?
      current_user.update(logged_in: true)
      copy_basket_from_last_user()
      current_user.sync_agb_with_basket
    end
  end


  def login_via_email
    do_transition_action :login_via_email do
      @current_user = self.current_user = User.find(params[:id])
      create_auth_cookie

      if logged_in?
        current_user.update(logged_in: true)
        copy_basket_from_last_user()
        current_user.sync_agb_with_basket
      end

      redirect_to home_page
    end
  end


  def logout
    current_basket.delete_if_obsolete if current_basket
    current_user.update(logged_in: false) unless current_user.class == Guest
    hobo_logout
  end


  def switch
    last_user_id = current_user.id
    self.current_user.update(logged_in: false)
    current_basket.delete_if_obsolete

    hobo_logout do
      session[:last_user] = last_user_id
      redirect_to :user_login
    end
  end


  def do_resend_email_confirmation
    current_user.lifecycle.generate_key
    current_user.save
    UserMailer.activation(current_user, current_user.lifecycle.key).deliver_now
    redirect_to order_path(current_user.basket)
  end


  def request_email_login
    @user = User.find_by_email_address(params[:email_address])
    if @user
      @user.lifecycle.generate_key
      @user.save # Otherwise key_timstamp gets not persisted
      UserMailer.login_link(@user, @user.lifecycle.key)
                .deliver_now
    end
  end


  def do_activate
    do_transition_action :activate
    flash[:notice] = I18n.t("mercator.messages.user.activated")
  end


  def accept_gtc
    @current_gtc = Gtc.order(version_of: :desc).first

    transition_page_action :accept_gtc do
      self.this.confirmation = false
      self.this.order_id = params[:order_id]
    end
  end


  def do_accept_gtc
    do_transition_action :accept_gtc do
      @order_id = params[:order_id] || params[:user][:order_id]
      if this.confirmation == "1"
        current_user.update(gtc_version_of: Gtc.current,
                            gtc_confirmed_at: Time.now())
        current_user.basket.update(gtc_version_of: Gtc.current,
                                   gtc_confirmed_at: Time.now())
        redirect_to order_path(@order_id)
      else
        flash[:error] = I18n.t("mercator.messages.user.accept_gtc.error")
        redirect_to action: :accept_gtc, order_id: @order_id
      end
    end
  end


  def upgrade
    if current_user.update_attributes(params[:user])
      current_user.lifecycle.generate_key
      current_user.save

      UserMailer.activation(current_user, current_user.lifecycle.key).deliver_now
      flash[:notice] = I18n.t("mercator.messages.user.confirm_and_refresh")
    else
      flash[:error] = I18n.t("mercator.messages.user.upgrade.error")
    end

    @user = current_user #testing access

    redirect_to params[:page_path]
  end


  def edit
    if params[:id] == "guest"
      # This is for the case, we are ready to login, but user decides to change a guest account
      self.current_user = session[:last_user] ? User.find(session[:last_user]) : User.initialize
      params[:id] = current_user.id
    end

    hobo_edit do
      if self.this.email_address.split("@")[1] == "mercator.informatom.com"
        self.this.email_address = nil
      end
    end
  end


  show_action :account do
    @user = self.this = User.find(params[:id])

    if self.this.email_address.split("@")[1] == "mercator.informatom.com"
      self.this.email_address = nil
    end
  end

  private

  def copy_basket_from_last_user
    @last_user = User.find(session[:last_user]) if session[:last_user]

    if @last_user
      @last_basket = @last_user.basket
      Conversation.where(customer_id: @last_user.id)
                  .update_all(customer_id: current_user.id)
    end

    @last_basket.try(:delete_if_obsolete)

    if @last_basket && !@last_basket.frozen?
      # This strange hoop, to not create a useless basket:
      @parked_basket_id = current_basket.id
      current_basket.lifecycle.park!(current_user)
      Order.find(@parked_basket_id).delete_if_obsolete

      @last_basket.update(user_id: current_user.id)
      Lineitem.where(order_id: @last_basket.id)
              .update_all(user_id: current_user.id)
    end
  end
end