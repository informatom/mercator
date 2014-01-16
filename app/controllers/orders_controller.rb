class OrdersController < ApplicationController

  hobo_model_controller
  auto_actions_for :user, :index

end