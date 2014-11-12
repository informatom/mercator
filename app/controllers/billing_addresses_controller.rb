class BillingAddressesController < ApplicationController

  before_filter :domain_shop_redirect

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
      if (Rails.application.config.try(:erp) == "mesonic" && Rails.env == "production")
        current_user.update_mesonic(billing_address: self.this)
      end

      if params[:billing_address][:order_id].present?
        redirect_to enter_billing_addresses_path({:order_id => params[:billing_address][:order_id]})
      else
        redirect_to user_path(current_user.id)
      end
    end
  end


  def enter
    self.this = BillingAddress.new(user: current_user, order_id: params[:order_id], email_address: current_user.email_address)

    unless current_user.state == "guest"
      self.this.attributes = current_user.namely [:gender, :title, :first_name, :surname, :email_address, :phone]
    end

    if current_user.billing_addresses.any?
      last_address = current_user.billing_addresses.last
      self.this.attributes = last_address.namely [:company, :gender, :title, :first_name, :surname,
                                                  :detail, :street, :postalcode, :city, :country, :phone]
    end

    creator_page_action :enter
  end


  def do_enter
    do_creator_action :enter do
      self.this.user = current_user
      order = Order.where(id: params[:billing_address][:order_id], user_id: current_user.id ).first

      if current_user.state == "guest"

        if this.valid?
            current_user.attributes = this.namely [:gender, :title, :first_name, :surname, :email_address, :phone]
          if current_user.save
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
        if Rails.application.config.try(:erp) == "mesonic" && Rails.env == "production"
          if current_user.erp_account_nr.present?
            current_user.update_mesonic(billing_address: self.this)
          else
            current_user.push_to_mesonic
          end
        end

        order.attributes = this.namely [:company, :gender, :title, :first_name, :surname,
                                        :detail, :street, :postalcode, :city, :country, :phone], prefix: "billing_"
        order.attributes = this.namely [:company, :gender, :title, :first_name, :surname,
                                        :detail, :street, :postalcode, :city, :country, :phone], prefix: "shipping_"
        order.billing_method = "e_payment"
        order.save

        Address.create(this.namely([:company, :gender, :title, :first_name, :surname,
                                    :detail, :street, :postalcode, :city, :country, :phone])
                       .merge(user_id: current_user.id))

        order.lifecycle.parcel_service_shipment!(current_user) unless order.shipping_method
        redirect_to order_path(order)
      end
    end
  end

  def do_use
    do_transition_action :use do
      order = Order.where(id: params[:order_id], user_id: current_user.id ).first
      order.update(this.namely([:company, :gender, :title, :first_name, :surname,
                                :detail, :street, :postalcode, :city, :country, :phone], prefix: "billing_"))

      if (Rails.application.config.try(:erp) == "mesonic" && Rails.env == "production")
        current_user.update_mesonic(billing_address: self.this)
      end

      order.lifecycle.e_payment!(current_user) unless order.shipping_method

      unless order.shipping_company
        order.update(this.namely([:company, :gender, :title, :first_name, :surname,
                                  :detail, :street, :postalcode, :city, :country, :phone], prefix: "shipping_"))
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