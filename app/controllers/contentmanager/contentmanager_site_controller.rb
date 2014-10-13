class Contentmanager::ContentmanagerSiteController < ApplicationController

  hobo_controller
  before_filter :contentmanager_required
  before_filter :domain_shop_redirect

  private

  def contentmanager_required
    redirect_to user_login_path unless logged_in? && current_user.contentmanager?
  end

end