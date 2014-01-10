class PagesController < ApplicationController

  hobo_model_controller
  auto_actions :show

  def show
    hobo_show do
      render "page_templates/" + @this.page_template.name
    end
  end

end