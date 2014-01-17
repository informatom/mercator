class ConversationsController < ApplicationController

  hobo_model_controller

  auto_actions :new, :create, :show, :index

  def create
    hobo_create do
      this.consultant = User.sales.where(logged_in: true).first
      this.customer = current_user
      this.save
      basket = Order.where(id: session[:basket]).first
      basket.update_attributes(conversation_id: this.id)
    end
  end
end
