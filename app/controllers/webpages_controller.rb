class WebpagesController < ApplicationController
  before_filter :domain_cms_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions :show


  def show
    if ["webpages", "pages"].include? request.path.split("/")[1]
      redirect_to request.url.sub(request.path.split("/")[1]+"/", ""), status: 301 and return
    end


    self.this = @webpage = Webpage.friendly.find(params[:id])

    hobo_show do
      if @webpage.visible_for?(user: current_user)
        render "page_templates/" + @webpage.page_template.name
      else
        redirect_to :root, status: 303
      end
    end
  end
end