class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :auto_log_in, except: [:login, :logout]
  before_filter :remember_uri

  def auto_log_in
    if current_user.guest?
      self.current_user = User.initialize
      Order.create(user: current_user)
      session[:compared] = []
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def remember_uri
    session[:return_to] = request.referrer
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def user_for_paper_trail
    logged_in? ? current_user : 'Guest'
  end

  def current_basket
    current_user.basket if current_user
  end
end
