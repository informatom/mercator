class OrdersController < ApplicationController

  hobo_model_controller
  auto_actions :edit, :update, :index, :show
  auto_actions_for :user, :index

  def update
    hobo_update do
      redirect_to action: :edit
    end
  end
end