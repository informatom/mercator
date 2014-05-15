class Sales::LinksController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all

  def create
    hobo_create do
      unless this.url[0..6] == "http://"
       this.url = "http://" + this.url
       this.save
      end
      PrivatePub.publish_to("/conversations/"+ this.conversation.id.to_s, type: "links", url: params[:link][:url])
    end
  end
end