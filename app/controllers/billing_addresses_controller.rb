class BillingAddressesController < ApplicationController

  hobo_model_controller
  auto_actions :edit, :update, :lifecycle
  auto_actions_for :user, [ :index, :new, :create ]

  def edit
    hobo_edit do
      self.this.order_id = params[:order_id]
    end
  end

  def update
    hobo_update do
      if (Rails.application.config.erp == "mesonic" && Rails.env == "production")
        current_user.update_mesonic(billing_address: self.this)
      end

      if params[:billing_address][:order_id]
        redirect_to enter_billing_addresses_path({:order_id => params[:billing_address][:order_id]})
      else
        redirect_to enter_billing_addresses_path
      end
    end
  end

  def enter
    self.this = BillingAddress.new(user: current_user, order_id: params[:order_id])

    unless current_user.state == "guest"
      self.this.name = current_user.name
      self.this.email_address= current_user.email_address
    end

    if current_user.billing_addresses.any?
      last_address = current_user.billing_addresses.last
      self.this.name = last_address.name
      self.this.c_o = last_address.c_o
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
      order = Order.where(id: params[:billing_address][:order_id], user_id: current_user.id ).first

      if current_user.state == "guest"
        name = this.email_address.split('@')[0].tr('.', ' ') if this.email_address.present?

        if this.valid? 
          if current_user.update(name: name.titlecase, email_address: this.email_address)
            UserMailer.activation(current_user, current_user.lifecycle.key).deliver
          else
            self.this.email_address = nil
            self.this.errors.clear
            self.this.errors.add(:email_address, I18n.t("mercator.messages.user.update_email.error"))
            render action: :enter, order_id: order.id and return
          end
        end
      end

      if self.this.save
        if (Rails.application.config.erp == "mesonic" && Rails.env == "production")
          current_user.update_mesonic(billing_address: self.this)
        end

        order.update(billing_name:        this.name,
                     billing_c_o:         this.c_o,
                     billing_detail:      this.detail,
                     billing_street:      this.street,
                     billing_postalcode:  this.postalcode,
                     billing_city:        this.city,
                     billing_country:     this.country,
                     billing_method:      "e_payment",
                     shipping_name:       this.name,
                     shipping_c_o:        this.c_o,
                     shipping_detail:     this.detail,
                     shipping_street:     this.street,
                     shipping_postalcode: this.postalcode,
                     shipping_city:       this.city,
                     shipping_country:    this.country)

        Address.create(name:       this.name,
                       c_o:        this.c_o,
                       detail:     this.detail,
                       street:     this.street,
                       postalcode: this.postalcode,
                       city:       this.city,
                       country:    this.country,
                       user:       current_user)
        order.lifecycle.parcel_service_shipment!(current_user) unless order.shipping_method
        redirect_to order_path(order)
      end
    end
  end

  def do_use
    do_transition_action :use do
      order = Order.where(id: params[:order_id], user_id: current_user.id ).first

      order.update(billing_name:       this.name,
                   billing_c_o:        this.c_o,
                   billing_detail:     this.detail,
                   billing_street:     this.street,
                   billing_postalcode: this.postalcode,
                   billing_city:       this.city,
                   billing_country:    this.country)

      if (Rails.application.config.erp == "mesonic" && Rails.env == "production")
        current_user.update_mesonic(billing_address: self.this)
      end

      order.lifecycle.e_payment!(current_user) unless order.shipping_method

      unless order.shipping_name
        order.update(shipping_name:       this.name,
                     shipping_c_o:        this.c_o,
                     shipping_detail:     this.detail,
                     shipping_street:     this.street,
                     shipping_postalcode: this.postalcode,
                     shipping_city:       this.city,
                     shipping_country:    this.country)
        order.lifecycle.parcel_service_shipment!(current_user) unless order.shipping_method
      end

      redirect_to order_path(order)
    end
  end

  def do_trash
    do_transition_action :trash do
      self.this.delete
      redirect_to enter_billing_addresses_path({:order_id => params[:order_id]})
    end
  end
end