class Sales::LinksController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all

  def create
    hobo_create do
      PrivatePub.publish_to("/conversations/"+ this.conversation.id.to_s, type: "links", url: params[:link][:url])
    end
  end

end
