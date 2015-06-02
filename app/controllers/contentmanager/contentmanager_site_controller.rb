class Contentmanager::ContentmanagerSiteController < ApplicationController

  hobo_controller
  before_filter :contentmanager_required
  before_filter :domain_shop_redirect

  private

  def contentmanager_required
    unless logged_in? &&
           (current_user.contentmanager? || current_user.administrator?)
      redirect_to user_login_path
    end
  end
end