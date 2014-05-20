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
    if Rails.env.production?
      begin
        unless (request.domain == Constant.find_by_key('cms_domain').value.split(".",2)[1] &&
                request.subdomains[0] == Constant.find_by_key('cms_domain').value.split(".",2)[0] ) || request.domain == nil
          new_url = 'http://' + Constant.find_by_key('cms_domain').value + request.path
          redirect_to new_url, :status => 301
        end
      rescue
      end
    end
  end

  def domain_shop_redirect
    if Rails.env.production?
      begin
        Constant.find_by_key('shop_domain').value
        unless request == nil || (request.domain == Constant.find_by_key('shop_domain').value.split(".",2)[1] &&
                                  request.subdomains[0] == Constant.find_by_key('shop_domain').value.split(".",2)[0] ) || request.domain == nil
          new_url = 'http://' + Constant.find_by_key('shop_domain').value + request.path
          redirect_to new_url, :status => 301
        end
      rescue
      end
    end
  end
end