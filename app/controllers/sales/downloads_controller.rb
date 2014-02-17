class Sales::DownloadsController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all

  def destroy
    PrivatePub.publish_to("/conversations/"+ Download.find(params[:id]).conversation.id.to_s, type: "downloads")
    hobo_destroy
  end

  def update
    PrivatePub.publish_to("/conversations/"+ Download.find(params[:id]).conversation.id.to_s, type: "downloads")
    hobo_update
  end

end