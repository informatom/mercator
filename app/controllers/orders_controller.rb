class OrdersController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    hobo_index Order.apply_scopes(:search => [params[:search], :billing_method, :shipping_method],
        :order_by => parse_sort_param(:created_at))
  end
end
