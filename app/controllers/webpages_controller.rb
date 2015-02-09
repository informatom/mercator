class WebpagesController < ApplicationController

  hobo_model_controller
  auto_actions :show
  index_action :viewtest

  before_filter :domain_cms_redirect

  def show
    self.this = @webpage = Webpage.friendly.find(params[:id])
    hobo_show do
      render "page_templates/" + self.this.page_template.name
    end
  end
end