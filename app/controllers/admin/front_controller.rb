class Admin::FrontController < Admin::AdminSiteController

  hobo_controller

  def index
    @orders_in_payment = Order.where(state: :in_payment)
  end
end