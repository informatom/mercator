class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :auto_log_in, except: [:login, :logout, :login_via_email]
  before_filter :remember_uri
  after_filter :allow_iframe
  before_filter  :log_database_access if Rails.env == "development"


  def log_database_access
    Rails.logger.level = 0
  end


  def auto_log_in
    if params[:remember_token]
      self.current_user = User.find_by_remember_token(params[:remember_token])
      params.delete :remember_token
      redirect_to request.path, :params => params, :status => 301
    end

    if self.current_user.guest?
      self.current_user = session[:last_user] ? User.find(session[:last_user]) : User.initialize
    end

  end


  def set_locale
    session[:locale] = I18n.locale = params[:locale] ||
                                     session[:locale] ||
                                     current_user.locale ||
                                     I18n.default_locale
    current_user.update(locale: I18n.locale) if current_user.class != Guest &&
                                                current_user.locale != I18n.locale.to_s
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


### Domainseperation ###

  def domain_cms_redirect
    return if request.url.include?(Constant::CMSDOMAIN)

    return if Constant::PODCASTDOMAIN && request.url.include?(Constant::PODCASTDOMAIN)

    new_url = case request.port
              when 80  then 'http://' + Constant::CMSDOMAIN + request.path
              when 443 then 'https://' + Constant::CMSDOMAIN + request.path
              else          'http://' + Constant::CMSDOMAIN + ":" + request.port.to_s + request.path
              end

    current_user.remember_me
    new_url = new_url + "?remember_token=" + current_user.remember_token

    redirect_to new_url, :status => 301
  end


  def domain_shop_redirect
    return if (request == nil || (request.url.include?(Constant::SHOPDOMAIN)))

    new_url = case request.port
              when 80  then 'http://' + Constant::SHOPDOMAIN + request.path
              when 443 then 'https://' + Constant::SHOPDOMAIN + request.path
              else          'http://' + Constant::SHOPDOMAIN + ":" + request.port.to_s + request.path
              end

    current_user.remember_me
    new_url = new_url + "?remember_token=" + current_user.remember_token

    redirect_to new_url, :status => 301
  end


  def request_param(parameter)
    query = request.query_string

    if query.present?
      query_params = CGI.parse(query)
      return query_params[parameter.to_s][0]
    else
      return nil
    end
  end


  def page_path_param(parameter)
    if params[:page_path]
      query ||= URI::parse(params[:page_path]).query
    end

    if query.present?
      query_params = CGI.parse(query)
      return query_params[parameter.to_s][0]
    else
      return nil
    end
  end


  def miniprofiler
    # enable this in a before_filter for profiling in production
    Rack::MiniProfiler.authorize_request
  end


protected

  def track_action
    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
  end


  def allow_iframe
    # We allow embedding in iframes
    response.headers.delete "X-Frame-Options"
  end
end