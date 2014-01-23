class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :index, :new, :create ]

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
      current_user.update_attributes(logged_in: true)

      last_user = User.find(session[:last_user])
      last_basket = last_user.basket if last_user

      if last_basket
        if current_basket.present?
          if current_basket.merge(basket: last_basket) == "merged"
            flash[:notice] = t("hobo.messages.old_basket_items_merged",
                             :default=>"Old basket items have been merged")
          end
        else
          current_user.orders << last_basket
        end
      end

      if last_user.conversations.any?
        last_user.conversations.each do |conversation|
          conversation.update_attributes(customer_id: current_user.id)
        end
      end
    end
  end

  def logout
    current_user.update_attributes(logged_in: false)
    hobo_logout
  end

  def switch
    last_user_id = current_user.id
    current_user.update_attributes(logged_in: false)
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
end