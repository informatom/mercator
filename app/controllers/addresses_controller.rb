class AddressesController < ApplicationController

  hobo_model_controller
  auto_actions_for :user, [ :index, :new, :create ]
  auto_actions :all, :lifecycle

  def enter
    last_address = current_user.addresses.last
    self.this = Address.new(user:       current_user,
                            c_o:        last_address.c_o,
                            name:       last_address.name,
                            detail:     last_address.detail,
                            street:     last_address.street,
                            postalcode: last_address.postalcode,
                            city:       last_address.city,
                            country:    last_address.country,
                            order_id:   params[:order_id])
    creator_page_action :enter
  end

  def do_enter
    do_creator_action :enter do
      order = Order.where(id: params[:address][:order_id], user_id: current_user.id ).first

      self.this.user = current_user
      if self.this.save
        order.update(shipping_name:       this.name,
                     shipping_c_o:        this.c_o,
                     shipping_detail:     this.detail,
                     shipping_street:     this.street,
                     shipping_postalcode: this.postalcode,
                     shipping_city:       this.city,
                     shipping_country:    this.country)

        order.lifecycle.parcel_service_shipment!(current_user) unless order.shipping_method
        redirect_to order_path(order)
      end
    end
  end

  def do_use
    do_transition_action :use do
      order = Order.where(id: params[:address][:order_id], user_id: current_user.id ).first

      order.update(shipping_name:       this.name,
                   shipping_c_o:        this.c_o,
                   shipping_detail:     this.detail,
                   shipping_street:     this.street,
                   shipping_postalcode: this.postalcode,
                   shipping_city:       this.city,
                   shipping_country:    this.country)

      order.lifecycle.parcel_service_shipment!(current_user) unless order.shipping_method
      redirect_to order_path(order)
    end
  end

  def do_trash
    do_transition_action :trash do
      self.this.delete
      redirect_to enter_addresses_path
    end
  end

    def update
    hobo_update do
      redirect_to enter_addresses_path
    end
  end
end