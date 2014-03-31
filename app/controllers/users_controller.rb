class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :index, :new, :create ]
  auto_actions :lifecycle

  # can be found in mercator/vendor/engines/mercator_mesonic/app/controllers/users_controller_extensions.rb
  include UsersControllerExtensions if Rails.application.config.erp == "mesonic"

  autocomplete :name

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
    hobo_login

    if logged_in?
      current_user.update(logged_in: true)

      last_user = User.find(session[:last_user])
      last_basket = last_user.basket if last_user

      if last_basket
        if current_basket.present?
          current_basket.lifecycle.park!(current_user)
        end
        current_user.orders << last_basket
      end

      unless current_user.basket
        Order.create(user: current_user)
      end

      current_user.sync_agb_with_basket

      if last_user.conversations.any?
        last_user.conversations.each do |conversation|
          conversation.update(customer_id: current_user.id)
        end
      end
    end
  end

  def logout
    current_user.update(logged_in: false)
    hobo_logout
  end

  def switch
    last_user_id = current_user.id
    current_user.update(logged_in: false)
    hobo_logout do
      session[:last_user] = last_user_id
      redirect_to :user_login
    end
  end

  def do_activate
    do_transition_action :activate do
      redirect_to :user_login
    end
  end

  def accept_gtc
    @current_gtc = Gtc.order(version_of: :desc).first
    transition_page_action :accept_gtc do
      self.this.confirmation = false
    end
  end

  def do_accept_gtc
    do_transition_action :accept_gtc do
      if this.confirmation == "1"
        current_user.update(gtc_version_of: Gtc.current,
                            gtc_confirmed_at: Time.now())
        current_user.basket.update(gtc_version_of: Gtc.current,
                                   gtc_confirmed_at: Time.now())
        redirect_to order_path(current_user.basket)
      else
        flash[:error] = "Sie müssen den allgemeinen Geschäftsbedingungen zustimmen, um den Bestellvorgang fortzusetzen!"
        redirect_to action: :accept_gtc
      end
    end
  end

end