class VideochatController < ApplicationController
  before_filter :domain_cms_redirect
  after_filter :track_action

  hobo_controller


  def show
    @channel_id = current_user.id
    current_user.update(waiting: true)
    current_user.delay.call_for_chat_partner(locale: I18n.locale)
  end


  def pickup
    @channel_id = params[:id]
    user = User.find(params[:id])
    user.update(waiting: false) if user
    render :show
  end
end