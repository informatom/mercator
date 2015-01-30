class ProductsController < ApplicationController

  before_filter :domain_shop_redirect

  hobo_model_controller
  auto_actions :show, :lifecycle
  index_action :comparison


  def do_add_to_basket
    do_transition_action :add_to_basket do
      current_user.basket.add_product(product: self.this)
      flash[:success] = I18n.t("mercator.messages.product.add_to_basket.success")
      flash[:notice] = nil
      PrivatePub.publish_to("/orders/"+ current_basket.id.to_s, type: "basket")
      redirect_to session[:return_to]
    end
  end


  def do_compare
    do_transition_action :compare do
      session[:compared] << this.id
      flash[:success] = I18n.t("mercator.messages.product.compare.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end


  def do_dont_compare
    do_transition_action :dont_compare do
      session[:compared].delete(this.id)
      flash[:success] = I18n.t("mercator.messages.product.dont_compare.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end


  def comparison
    @nested_hash = ActiveSupport::OrderedHash.new

    @this = @products = Product.where(id: session[:compared]).paginate(:page => 1, :per_page => session[:compared].length)

    redirect_to :root and return unless @products.any?

    @products = @products.sort_by { |a| session[:compared].index(a.id)}
    values = Value.where(product_id: session[:compared]).sort_by { |a| [a.property_group.position, a.property.position]}
    values.each do |value|
      property_name = value.property.name || value.property.name_en
      @nested_hash[value.property_group.name] ||= ActiveSupport::OrderedHash.new
      @nested_hash[value.property_group.name][property_name] ||= ActiveSupport::OrderedHash.new
      @nested_hash[value.property_group.name][property_name][value.product_id] = value.display
    end
    hobo_index
  end
end