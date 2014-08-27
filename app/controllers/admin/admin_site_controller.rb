class Admin::AdminSiteController < ApplicationController

  hobo_controller
  before_filter :admin_required
  before_filter :domain_shop_redirect

  private

  def admin_required
    redirect_to user_login_path unless logged_in? && current_user.administrator?
  end
end