class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :index, :new, :create ]
  auto_actions :lifecycle

  # can be found in mercator/vendor/engines/mercator_mesonic/app/controllers/users_controller_extensions.rb
  include UsersControllerExtensions if Rails.application.config.try(:erp) == "mesonic"

  autocomplete :surname

  # Normally, users should be created via the user lifecycle, except
  #  for the initial user created via the form on the front screen on
  #  first run.  This method creates the initial user.
  def create
    hobo_create do
      if valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_are_site_admin",
                         :default=>"You are now the site administrator")
        redirect_to home_page
      end
    end
  end

  def login
    if  params[:fromfront] == "true"
      last_user_id = current_user.id
      logout()
    end

    hobo_login
    if logged_in?
      current_user.update(logged_in: true)

      last_user = session[:last_user] ? User.find(session[:last_user]) : nil
      last_basket = last_user.basket

      current_basket.try(:delete_if_obsolete)
      last_basket.try(:delete_if_obsolete)

      if last_basket && !last_basket.frozen?
        current_basket.lifecycle.park!(current_user)
        last_basket.update(user_id: current_user.id)
        Lineitem.where(order_id: last_basket.id).update_all(user_id: current_user.id)
      end

      Order.create(user: current_user) unless current_user.basket
      current_user.sync_agb_with_basket
      Conversation.where(customer_id: last_user.id).update_all(customer_id: current_user.id)
    end
  end

  def login_via_email
    do_transition_action :login_via_email do
      self.current_user = User.find(params[:id])
      create_auth_cookie
      current_user.lifecycle.create_key!(current_user)
      redirect_to home_page
    end
  end

  def logout
    current_basket.delete_if_obsolete
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

  def request_email_login
    user = User.find_by_email_address(params[:email_address])
    if user
      user.lifecycle.create_key!(current_user)
      UserMailer.login_link(user, user.lifecycle.key).deliver
    end
  end

  def do_activate
    do_transition_action :activate do
      flash[:notice] = I18n.t("mercator.messages.user.activated")
      redirect_to :root
    end
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
      if this.confirmation == "1"
        current_user.update(gtc_version_of: Gtc.current,
                            gtc_confirmed_at: Time.now())
        current_user.basket.update(gtc_version_of: Gtc.current,
                                   gtc_confirmed_at: Time.now())
        if params[:order_id]
          redirect_to order_path(params[:order_id])
        else
          redirect_to order_path(params[:user][:order_id])
        end
      else
        flash[:error] = I18n.t("mercator.messages.user.accept_gtc.error")
        if params[:user][:order_id]
          redirect_to action: :accept_gtc, order_id: params[:user][:order_id]
        else
          redirect_to action: :accept_gtc, order_id: params[:order_id]
        end
      end
    end
  end

  def upgrade
    if current_user.update_attributes(params[:user])
      UserMailer.activation(current_user, current_user.lifecycle.key).deliver
      flash[:notice] = I18n.t("mercator.messages.user.confirm_and_refresh")
    else
      flash[:error] = I18n.t("mercator.messages.user.upgrade.error")
    end
    redirect_to params[:page_path]
  end
end