class AddressesController < ApplicationController
  before_filter :domain_shop_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions_for :user, [ :index, :new, :create ]
  auto_actions :all, :lifecycle


  def edit
    hobo_edit do
      self.this.order_id = params[:order_id]
    end
  end


  def update
    hobo_update do
      if params[:address][:order_id].present?
        redirect_to enter_addresses_path({:order_id => params[:address][:order_id]})
      else
        redirect_to user_path(current_user.id)
      end
    end
  end


  def enter
    last_address = current_user.addresses.last

    if last_address
      self.this = Address.new(last_address.namely([:company, :gender, :title, :first_name, :surname,
                                                   :detail, :street, :postalcode, :city, :country, :phone])
                              .merge(user_id: current_user.id, order_id: params[:order_id]))
    else
      self.this = Address.new(user_id: current_user.id, order_id: params[:order_id])
    end
    @address = self.this

    creator_page_action :enter
  end


  def do_enter
    do_creator_action :enter do
      @order = Order.find(params[:address][:order_id])

      self.this.user = current_user
      if self.this.save
        @order.update(this.namely([:company, :gender, :title, :first_name, :surname,
                                   :detail, :street, :postalcode, :city, :country, :phone], prefix: "shipping_"))
        @order.update(shipping_method: Order::DEFAULT_SHIPPING_METHOD) unless @order.shipping_method

        redirect_to order_path(@order)
      end
    end
  end


  def do_use
    do_transition_action :use do
      @order = Order.find(params[:order_id])
      @order.update(this.namely([:company, :gender, :title, :first_name, :surname,
                                 :detail, :street, :postalcode, :city, :country, :phone], prefix: "shipping_"))
      @order.update(shipping_method: Order::DEFAULT_SHIPPING_METHOD) unless @order.shipping_method

      redirect_to order_path(@order)
    end
  end


  def do_trash
    do_transition_action :trash do
      self.this.destroy
      redirect_to enter_addresses_path(order_id: params[:order_id])
    end
  end
end