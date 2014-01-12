class PagesController < ApplicationController

  hobo_model_controller
  auto_actions :show

  def show
    @this = @page = Page.friendly.find(params[:id])
    render "page_templates/" + @this.page_template.name
  end
end