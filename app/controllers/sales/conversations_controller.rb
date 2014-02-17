class Sales::ConversationsController < Sales::SalesSiteController

  hobo_model_controller
  auto_actions :all, :lifecycle

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

  def do_upload
    do_transition_action :upload do
      data = params[:qqfile]
      data.class.class_eval { attr_accessor :original_filename }
      data.original_filename = params[:qqfilename]
      if params[:qqfile].content_type.split("/")[0] == "image"
        self.this.downloads.create(name: params[:qqfilename].split(".")[0], photo: data)
      else
        self.this.downloads.create(name: params[:qqfilename].split(".")[0], document: data)
      end  
      render :json => { :success => "true" }
      PrivatePub.publish_to("/conversations/"+ this.id.to_s, type: "downloads")
    end
  end
end