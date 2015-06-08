class Sales::LinksController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all


  def create
    hobo_create do
      if this.url.present?
        # List of URI-Schemes: https://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml
        unless this.url[0..6].start_with?("http://", "https://", "ftp://", "sftp://", "mailto://", "skype://", "gtalk://")
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