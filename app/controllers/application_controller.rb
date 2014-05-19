class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :auto_log_in, except: [:login, :logout]
  before_filter :remember_uri

  def auto_log_in
    if current_user.guest?
      if session[:last_user]
        self.current_user = User.find(session[:last_user])
      else
        self.current_user = User.initialize
        Order.create(user: current_user)
      end
    end
  end

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || current_user.locale || I18n.default_locale
    session[:locale] = I18n.locale
    if current_user.class != Guest
      current_user.update(locale: I18n.locale) if current_user.locale != I18n.locale
    end
  end

  def remember_uri
    session[:return_to] = request.referrer
    session[:compared] ||= []
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
