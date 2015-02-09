class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :auto_log_in, except: [:login, :logout, :login_via_email]
  before_filter :remember_uri
  # after_filter :track_action

  def auto_log_in
    self.current_user = User.find_by_remember_token(params[:remember_token]) if params[:remember_token]
    self.current_user = User.find(session[:last_user]) if session[:last_user]
    self.current_user = User.initialize if self.current_user.guest?
  end

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || current_user.locale || I18n.default_locale
    session[:locale] = I18n.locale
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

# Domainseperation
  def domain_cms_redirect
    cms_domain = Constant.find_by_key('cms_domain').value
    return if request.url.include?(cms_domain)

    podcast_domain = Constant.find_by_key('podcast_domain').try(:value)
    return if podcast_domain && request.url.include?(podcast_domain)

    new_url = case request.port
              when 80  then 'http://' + cms_domain + request.path
              when 443 then 'https://' + cms_domain + request.path
              else          'http://' + cms_domain + ":" + request.port.to_s + request.path
              end

    current_user.remember_me
    new_url = new_url + "?remember_token=" + current_user.remember_token

    redirect_to new_url, :status => 301
  end

  def domain_shop_redirect
    shop_domain = Constant.find_by_key('shop_domain').value
    return if (request == nil || (request.url.include?(shop_domain)))

    new_url = case request.port
              when 80  then 'http://' + shop_domain + request.path
              when 443 then 'https://' + shop_domain + request.path
              else          'http://' + shop_domain + ":" + request.port.to_s + request.path
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
    query ||= URI::parse(params[:page_path]).query

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

#  FIXME! Commented out because uploads kill it ...
#  def track_action
#    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
#  end
end