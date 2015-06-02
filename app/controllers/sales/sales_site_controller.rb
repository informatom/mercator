class Sales::SalesSiteController < ApplicationController

  hobo_controller
  before_filter :sales_required
  before_filter :domain_shop_redirect

  private

  def sales_required
    unless logged_in? &&
           (current_user.sales? || current_user.administrator? ||
                                   current_user.contentmanager? ||
                                   current_user.salesmanager? ||
                                   current_user.productmanager?)
      redirect_to home_page
    end
  end
end