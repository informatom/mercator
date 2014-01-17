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
        flash[:notice] = t("hobo.messages.you_are_site_admin", :default=>"You are now the site administrator")
        redirect_to home_page
      end
    end
  end

  def login
    hobo_login
    unless current_user.class == Guest
      current_user.update_attributes(logged_in: true)

      guest_basket = Order.where(id:session[:basket]).first

      if current_basket.present?
        if current_basket.merge(basket: guest_basket) == "merged"
          flash[:notice] = t("hobo.messages.old_basket_items_merged",
                           :default=>"Old basket items have been merged")
        end
        session[:basketkey] = current_basket.lifecycle.key
        session[:basket] = current_basket.id
      else
        current_user.orders << guest_basket
      end
    end
  end

  def logout
    current_user.update_attributes(logged_in: false)
    hobo_logout
  end

  def do_activate
    do_transition_action :activate do
      redirect_to :user_login
    end
  end

end
