class BillingAddressesController < ApplicationController
  before_filter :domain_shop_redirect
  after_filter :track_action

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

    if Constant.find_by_key('default_country')  && ! self.this.country
      self.this.country = Constant.find_by_key('default_country').value
    end

    if self.this.email_address.split("@")[1] == "mercator.informatom.com"
      self.this.email_address = nil
    end

    if self.this.surname == "Gast"
      self.this.surname = nil
    end

    creator_page_action :enter
  end


  def do_enter
    do_creator_action :enter do
      current_user.billing_addresses.where.not(id: self.this.id).delete_all

      @billing_address = self.this
      self.this.user = current_user
      @order = Order.find(params[:billing_address][:order_id])

      if ["guest", "inactive"].include?(current_user.state)
        if this.valid?
          if current_user.update(this.namely [:gender, :title, :first_name, :surname,
                                              :email_address, :phone])
            current_user.lifecycle.generate_key unless current_user.lifecycle.key
            UserMailer.activation(current_user, current_user.lifecycle.key).deliver
          else
            self.this.email_address = nil
            self.this.errors.clear
            self.this.errors.add(:email_address, I18n.t("mercator.messages.user.update_email.error"))
            render action: :enter, order_id: @order.id and return
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

        @order.attributes = this.namely [:company, :gender, :title, :first_name, :surname,
                                        :detail, :street, :postalcode, :city, :country, :phone], prefix: "billing_"
        @order.attributes = this.namely [:company, :gender, :title, :first_name, :surname,
                                        :detail, :street, :postalcode, :city, :country, :phone], prefix: "shipping_"
        @order.billing_method = Order::DEFAULT_BILLING_METHOD
        @order.save

        Address.create(this.namely([:company, :gender, :title, :first_name, :surname,
                                    :detail, :street, :postalcode, :city, :country, :phone])
                       .merge(user_id: current_user.id))

        @order.update(shipping_method: Order::DEFAULT_SHIPPING_METHOD) unless @order.shipping_method

        if @order.shipping_method.to_s == "parcel_service_shipment"
          @order.add_shipment_costs
        end

        redirect_to order_path(@order)
      end
    end
  end
end