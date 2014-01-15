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

      # The basket is assigned to the user after login
      current_user.orders << Order.where(id:session[:basket])
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
