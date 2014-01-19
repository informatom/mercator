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

  def initiate
    self.current_user = User.create(name: "Gast", email_address: Time.now.to_f.to_s + "@mercator.informatom.com") if current_user.guest?
    guest_basket = Order.where(id:session[:basket]).first
    current_user.orders << guest_basket
    creator_page_action :initiate
  end

  def do_initiate
    do_creator_action :initiate do
      this.customer = current_user
      this.consultant = User.sales.where(logged_in: true).first
      this.save
      basket = Order.where(id: session[:basket]).first
      basket.update_attributes(conversation_id: this.id)
    end
  end
end
