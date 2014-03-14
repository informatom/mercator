class ConversationsController < ApplicationController

  hobo_model_controller
  auto_actions :show, :index, :lifecycle
  show_action :suggestions

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
    self.this = Conversation.new(customer: current_user)
    current_basket.update(conversation_id: this.id)
    creator_page_action :initiate
  end

  def do_initiate
    PrivatePub.publish_to("/conversations/new", type: "conversations")

    do_creator_action :initiate do
      consultant = User.assign_consultant
      self.this.update(customer: current_user,
                       consultant: consultant)
      self.this.messages << Message.new(sender: consultant,
                                        reciever: current_user,
                                        content: "Guten Tag! Mein Name ist " + consultant.name + "Wie kann ich Ihnen helfen?")
    end
  end

  def do_feedback
    do_transition_action :feedback do
      @feedback = Feedback.new(content: params[:conversation][:content])
      case params[:conversation][:mode]
      when "all"
        @feedback.update(user_id:         this.customer_id,
                         consultant_id:   this.consultant_id,
                         conversation_id: this.id)
      when "user"
        @feedback.update(user_id: this.customer_id)
      when "consultant"
        @feedback.update(consultant_id: this.consultant_id)
      else
        @feedback.save
      end
    end
  end

  def suggestions
    @conversation = Conversation.find(params[:id])
    @this = @products = @conversation.products.paginate(:page => 1, :per_page => @conversation.products.count)
    hobo_index
  end

end