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
end