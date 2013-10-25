class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    if (params[:locale])
      I18n.locale = params[:locale]
    else if (current_user.signed_up?)
        I18n.locale = current_user.user_locale.to_s
      else
        I18n.locale=I18n.default_locale
      end
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
end
