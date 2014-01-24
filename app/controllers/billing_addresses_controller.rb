class BillingAddressesController < ApplicationController

  hobo_model_controller
  auto_actions :lifecycle
  auto_actions_for :user, [ :index, :new, :create ]

  def do_enter
    do_creator_action :enter do
      self.this.user = current_user
      if self.this.save
        current_basket.update(billing_name:       this.name,
                              billing_detail:     this.detail,
                              billing_street:     this.street,
                              billing_postalcode: this.postalcode,
                              billing_city:       this.city,
                              billing_country:    this.country,
                              shipping_name:       this.name,
                              shipping_detail:     this.detail,
                              shipping_street:     this.street,
                              shipping_postalcode: this.postalcode,
                              shipping_city:       this.city,
                              shipping_country:    this.country)

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
end