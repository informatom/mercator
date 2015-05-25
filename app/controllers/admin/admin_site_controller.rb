class Admin::AdminSiteController < ApplicationController

  hobo_controller
  before_filter :admin_required
  before_filter :domain_shop_redirect

  private

  def admin_required
    unless logged_in? && current_user.administrator?
      redirect_to user_login_path
    end
  end
end