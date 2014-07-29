class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :auto_log_in, except: [:login, :logout, :login_via_email]
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
    current_user.update(locale: I18n.locale) if (current_user.class != Guest ) && (current_user.locale != I18n.locale.to_s)
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

# Domainseperation
  def domain_cms_redirect
    cms_domain = Constant.find_by_key('cms_domain').value

    unless request.url.include?(cms_domain)
      if (request.port > 443)
        new_url = 'http://' + cms_domain + ":" + request.port.to_s + request.path
      else
        new_url = 'http://' + cms_domain + request.path
      end
      redirect_to new_url, :status => 301
    end
  end

  def domain_shop_redirect
    shop_domain = Constant.find_by_key('shop_domain').value
    unless request == nil || (request.url.include?(shop_domain))
      if (request.port > 443)
        new_url = 'http://' + shop_domain + ":" + request.port.to_s + request.path
      else
        new_url = 'http://' + shop_domain + request.path
      end
      redirect_to new_url, :status => 301
    end
  end
end