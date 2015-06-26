class WebpagesController < ApplicationController
  before_filter :domain_cms_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions :show


  def show
    self.this = @webpage = Webpage.friendly.find(params[:id])

    unless  @webpage.visible_for?(user: current_user)
      redirect_to :root, status: 303 and return
    end

    if ["webpages", "pages"].include? request.path.split("/")[1]
      redirect_to request.url.sub(request.path.split("/")[1]+"/", ""), status: 301 and return
    end

    hobo_show do
      render "page_templates/" + @webpage.page_template.name
    end
  end
end