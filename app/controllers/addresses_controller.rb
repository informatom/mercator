class AddressesController < ApplicationController

  hobo_model_controller
  auto_actions_for :user, [ :index, :new, :create ]
  auto_actions :lifecycle

  def enter
    last_address = current_user.addresses.last
    self.this = Address.new(user:       current_user,
                            name:       last_address.name,
                            detail:     last_address.detail,
                            street:     last_address.street,
                            postalcode: last_address.postalcode,
                            city:       last_address.city,
                            country:    last_address.country)
    creator_page_action :enter
  end

  def do_enter
    do_creator_action :enter do
      self.this.user = current_user
      if self.this.save
        current_basket.update(shipping_name:       this.name,
                              shipping_detail:     this.detail,
                              shipping_street:     this.street,
                              shipping_postalcode: this.postalcode,
                              shipping_city:       this.city,
                              shipping_country:    this.country,
                              shipping_method:     "parcel_service_shipment")
        redirect_to order_path(current_user.basket)
      end
    end
  end

  def do_use
    do_transition_action :use do
      current_basket.update(shipping_name:       this.name,
                      shipping_detail:     this.detail,
                      shipping_street:     this.street,
                      shipping_postalcode: this.postalcode,
                      shipping_city:       this.city,
                      shipping_country:    this.country,
                      shipping_method:     "parcel_service_shipment")
      redirect_to order_path(current_user.basket)
    end
  end

  def do_trash
    do_transition_action :trash do
      self.this.delete
      redirect_to enter_addresses_path
    end
  end
end