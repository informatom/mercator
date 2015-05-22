class Admin::FrontController < Admin::AdminSiteController

  hobo_controller

  def index
    @orders_in_payment = Order.where(status: :in_payment)
  end


  def search
    site_search(params[:query]) if params[:query]
  end
end