class Productmanager::FrontController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js

  def index; end

end