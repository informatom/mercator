class ConversationsController < ApplicationController

  hobo_model_controller

  auto_actions :show, :index, :lifecycle

  def refresh
    self.this = Conversation.find(params[:id])
    hobo_show
  end

  def show
    hobo_show do
      if current_user.guest? || current_user.id == this.customer_id
        reciever_id = this.consultant_id
      else
        reciever_id = this.customer_id
      end

      sender_id = current_user.id if logged_in?

      @message = Message.new(reciever_id: reciever_id,
                             conversation_id: this.id,
                             sender_id: sender_id)
    end
  end

  def do_initiate
    do_creator_action :initiate do
      this.update_attributes(customer: current_user,
                             consultant: User.sales.where(logged_in: true).first)
      current_basket.update_attributes(conversation_id: this.id)
    end
  end
end
