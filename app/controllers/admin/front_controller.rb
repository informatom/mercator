class Admin::FrontController < Admin::AdminSiteController

  hobo_controller

  def index; end

  def summary
    redirect_to user_login_path unless current_user.administrator?
  end

  def search
    site_search(params[:query]) if params[:query]
  end
end