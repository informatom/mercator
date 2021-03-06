class Sales::DownloadsController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all

  def destroy
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ Download.find(params[:id]).conversation.id.to_s,
                          type: "downloads")
    hobo_destroy
  end


  def update
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ Download.find(params[:id]).conversation.id.to_s,
                          type: "downloads")
    hobo_update
  end


  def create
    if params[:download][:document].content_type.split("/")[0] == "image"
      params[:download][:photo] =  params[:download][:document]
      params[:download][:document] = nil
      self.this = @download = Download.new(params[:download])
      @download.name = File.basename(@download.photo_file_name, '.*')
    else
      self.this = @download = Download.new(params[:download])
      @download.name = File.basename(@download.document_file_name, '.*')
    end

    hobo_create do
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ @download.conversation_id.to_s,
                            type: "downloads")
      render :json => { :success => "true" }
    end
  end
end
