class Productmanager::ProductmanagerSiteController < ApplicationController

  hobo_controller
  before_filter :productmanager_required
  before_filter :domain_shop_redirect

  private

  def productmanager_required
    redirect_to user_login_path unless logged_in? && current_user.administrator?
  end
end