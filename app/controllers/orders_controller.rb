class OrdersController < ApplicationController

  hobo_model_controller
  auto_actions :index, :show, :lifecycle
end