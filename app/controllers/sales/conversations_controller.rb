class Sales::ConversationsController < Sales::SalesSiteController

  hobo_model_controller
  auto_actions :all, :lifecycle

  def refresh
    self.this = Conversation.find(params[:id])
    hobo_show
  end

  def take
    self.this = Conversation.find(params[:id])
    this.update(consultant: current_user)
    PrivatePub.publish_to("/conversations/"+ this.id.to_s, type: "consultant")

    this.messages << Message.new(reciever_id: self.this.customer_id,
                                 sender_id: current_user.id,
                                 content: I18n.t("mercator.salutation.success",
                                                 first_name: current_user.first_name,
                                                 surname: current_user.surname))
    PrivatePub.publish_to("/conversations/"+ this.id.to_s, type: "messages")

    redirect_to sales_conversation_path(this)
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

  def do_upload
    do_transition_action :upload do
      data = params[:qqfile]
      data.class.class_eval { attr_accessor :original_filename }
      data.original_filename = params[:qqfilename]
      if params[:qqfile].content_type.split("/")[0] == "image"
        this.downloads.create(name: params[:qqfilename].split(".")[0], photo: data)
      else
        this.downloads.create(name: params[:qqfilename].split(".")[0], document: data)
      end
      render :json => { :success => "true" }
      PrivatePub.publish_to("/conversations/"+ this.id.to_s, type: "downloads")
    end
  end
end