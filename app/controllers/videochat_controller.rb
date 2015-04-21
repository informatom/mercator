class VideochatController < ApplicationController
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

  def current_user
    User.find(session[:user].split(":")[1])
  end

private

  def logged_in?
    true
  end
end