class WebpagesController < ApplicationController

  hobo_model_controller
  auto_actions :show
  index_action :viewtest

  before_filter :domain_cms_redirect

  def show
    self.this = @webpage = Webpage.friendly.find(params[:id])

    hobo_show do
      if ["published", "published_but_hidden"].include? @webpage.state
        render "page_templates/" + self.this.page_template.name
      else
        redirect_to :root, status: 303
      end
    end
  end
end