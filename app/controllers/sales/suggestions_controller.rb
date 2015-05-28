class Sales::SuggestionsController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all

  def destroy
    hobo_destroy do
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ self.this.conversation_id.to_s,
                            type: "suggestions")
    end
  end

  def update
    hobo_update do
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ self.this.conversation_id.to_s,
                            type: "suggestions")
    end
  end

  def create
    hobo_create do
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ self.this.conversation_id.to_s,
                            type: "suggestions")
    end
  end

  def show
    hobo_show do
      session[:current_conversation_id] = self.this.id
    end
  end
end