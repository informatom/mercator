class ConversationsController < ApplicationController

  hobo_model_controller

  auto_actions :new, :create, :show, :index

  def refresh
    self.this = Conversation.find(params[:id])
    hobo_show
  end

  def show
    hobo_show do
      if current_user.id == this.customer_id
        reciever_id = this.consultant_id
      else
        reciever_id = this.customer_id
      end

      @message = Message.new(reciever_id: reciever_id,
                             conversation_id: this.id,
                             sender_id: current_user.id)
    end
  end

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
