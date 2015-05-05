class VideochatController < ApplicationController
  hobo_controller

  before_filter :domain_cms_redirect
  layout nil

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