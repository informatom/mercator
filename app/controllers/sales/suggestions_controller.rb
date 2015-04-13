class Sales::SuggestionsController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all

  def destroy
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ Suggestion.find(params[:id]).conversation_id.to_s,
                          type: "suggestions")
    hobo_destroy
  end

  def update
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ Suggestion.find(params[:id]).conversation_id.to_s,
                          type: "suggestions")
    hobo_update
  end

  def create
    hobo_create do
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ self.this.conversation_id.to_s,
                            type: "suggestions")
    end
  end

  def show
    session[:current_conversation_id] = this.id
    hobo_show
  end
end