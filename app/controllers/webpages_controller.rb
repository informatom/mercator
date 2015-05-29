class WebpagesController < ApplicationController
  before_filter :domain_cms_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions :show

  #HAS 20150529 deprecated?
  # index_action :viewtest


  def show
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