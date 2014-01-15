class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :create_basket

  def create_basket
    unless @basket = my_basket
      @basket = Order.create
      @basket.lifecycle.create_key!(current_user)
      @basket.save
      session[:key] = @basket.lifecycle.key
      session[:basket] = @basket.id
    end
  end

  def my_basket
    @basket = Order.where(session[:basket]).first
    if @basket.lifecycle && @basket.lifecycle.key == session[:key]
      return @basket
    else
      return nil
    end
  end

  def set_locale
    if (params[:locale])
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end
end
