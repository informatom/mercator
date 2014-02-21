class BillingAddressesController < ApplicationController

  hobo_model_controller
  auto_actions :edit, :update, :lifecycle
  auto_actions_for :user, [ :index, :new, :create ]

  def enter
    self.this = BillingAddress.new(user: current_user)
    unless current_user.name == "Gast"
      self.this.name = current_user.name
      self.this.email_address= current_user.email_address
    end

    if current_user.billing_addresses.any?
      last_address = current_user.billing_addresses.last
      self.this.name = last_address.name
      self.this.detail = last_address.detail
      self.this.street = last_address.street
      self.this.postalcode = last_address.postalcode
      self.this.city = last_address.city
      self.this.country = last_address.country
    end

    creator_page_action :enter
  end


  def do_enter
    do_creator_action :enter do
      self.this.user = current_user
      if self.this.save
        current_basket.update(billing_name:        this.name,
                              billing_detail:      this.detail,
                              billing_street:      this.street,
                              billing_postalcode:  this.postalcode,
                              billing_city:        this.city,
                              billing_country:     this.country,
                              billing_method:      "e_payment",
                              shipping_name:       this.name,
                              shipping_detail:     this.detail,
                              shipping_street:     this.street,
                              shipping_postalcode: this.postalcode,
                              shipping_city:       this.city,
                              shipping_country:    this.country)

      if current_user.name == "Gast"
        current_user.update(email_address: this.email_address,
                            name:          this.email_address.split('@')[0].gsub!('.', ' ').titlecase)
      end

        Address.create(name:       this.name,
                       detail:     this.detail,
                       street:     this.street,
                       postalcode: this.postalcode,
                       city:       this.city,
                       country:    this.country,
                       user:       current_user)

        redirect_to order_path(current_user.basket)
      end
    end
  end

  def do_use
    do_transition_action :use do
      current_basket.update(billing_name:       this.name,
                            billing_detail:     this.detail,
                            billing_street:     this.street,
                            billing_postalcode: this.postalcode,
                            billing_city:       this.city,
                            billing_country:    this.country,
                            billing_method:     "parcel_service_shipment")

      unless current_basket.shipping_name
        current_basket.update(shipping_name:       this.name,
                              shipping_detail:     this.detail,
                              shipping_street:     this.street,
                              shipping_postalcode: this.postalcode,
                              shipping_city:       this.city,
                              shipping_country:    this.country,
                              shipping_method:     "parcel_service_shipment")
      end

      redirect_to order_path(current_user.basket)
    end
  end

  def do_trash
    do_transition_action :trash do
      self.this.delete
      redirect_to enter_billing_addresses_path
    end
  end
end