class Sales::ConversationsController < Sales::SalesSiteController

  hobo_model_controller
  auto_actions :all, :lifecycle

  def index
    self.this = @conversations = Conversation.paginate(:page => params[:page])
                                             .search([params[:search], :name, :customer_id, :consultant_id ])
                                             .order_by(parse_sort_param(:name, :updated_at, :created_at, :customer_id, :consultant_id))
    hobo_index
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
      @link = Link.new(conversation_id: this.id)
      @suggestion = Suggestion.new(conversation_id: this.id)
      session[:current_conversation_id] = this.id
    end
  end


  def destroy
    hobo_destroy(redirect: sales_conversations_path)
  end


  def refresh
    self.this = @conversation = Conversation.find(params[:id])
    hobo_show do
      render :show
    end
  end


  def take
    self.this = Conversation.find(params[:id])
    this.update(consultant: current_user)
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ this.id.to_s,
                          type: "consultant")

    this.messages << Message.new(reciever_id: self.this.customer_id,
                                 sender_id: current_user.id,
                                 content: I18n.t("mercator.salutation.success",
                                                 first_name: current_user.first_name,
                                                 surname: current_user.surname))
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ this.id.to_s,
                          type: "messages")

    redirect_to sales_conversation_path(this)
  end


  def typing
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ params[:id].to_s,
                          type: "typing",
                          message: params[:message])
    render nothing: true if request.xhr?
  end
end