class LinksController < ApplicationController

  hobo_model_controller

  auto_actions :create


  def create
    hobo_create do
      if this.url.present?
        unless this.url[0..6] == "http://"
          this.url = "http://" + this.url
        end

        uri = URI(this.url)
        uri.query.gsub!(/remember_token=\w*&*/,"") if uri.query.present?
        this.update(url: uri.to_s)
      end

      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ this.conversation.id.to_s,
                            type: "links",
                            url: params[:link][:url])
    end
  end
end