class Sales::SalesSiteController < ApplicationController

  hobo_controller
  before_filter :sales_required

  private

  def sales_required
    redirect_to home_page unless logged_in? && current_user.sales?
  end
end