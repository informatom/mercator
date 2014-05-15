class Admin::AdminSiteController < ApplicationController

  hobo_controller
  before_filter :admin_required

  private

  def admin_required
    redirect_to home_page unless logged_in? && current_user.administrator?
  end
end