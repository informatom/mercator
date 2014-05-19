class WebpagesController < ApplicationController

  hobo_model_controller
  auto_actions :show

  def show
    @this = Webpage.friendly.find(params[:id])
    hobo_show do
      render "page_templates/" + @this.page_template.name
    end
  end
end