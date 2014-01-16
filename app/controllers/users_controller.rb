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
      #HAS:20140109 WTF! reduce by one, because some other method increases by 2!
      current_user.update_attributes(logged_in: true)
      @new_basket = Order.where(id:session[:basket]).first
      # The basket is assigned to the user after login, positions are merged, user is warned
      if current_user.basket.present?
        if @new_basket.id != current_user.basket.id #first rum or second run?
          if current_user.basket.lineitems.present? && @new_basket.lineitems.any?
            flash[:notice] = t("hobo.messages.old_basket_items_merged",
                               :default=>"Old basket items have been merged")

          end
          @new_basket.lineitems.each do |lineitem|
            lineitem.update_attributes(order_id: current_user.basket.id)
            debugger
            lineitem.save
          end
          @new_basket.delete
          session[:basketkey] = current_user.basket.lifecycle.key
          session[:basket] = current_user.basket.id
        end
      else
        current_user.orders << @new_basket
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
