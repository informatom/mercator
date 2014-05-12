class Order < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billing_method      :string
    billing_name        :string
    billing_c_o         :string
    billing_detail      :string
    billing_street      :string
    billing_postalcode  :string
    billing_city        :string
    billing_country     :string
    shipping_method     :string
    shipping_name       :string
    shipping_c_o        :string
    shipping_detail     :string
    shipping_street     :string
    shipping_postalcode :string
    shipping_city       :string
    shipping_country    :string
    gtc_confirmed_at    :datetime
    gtc_version_of      :date
    erp_customer_number :string
    erp_billing_number  :string
    erp_order_number    :string
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/order_extensions.rb
  include OrderExtensions if Rails.application.config.erp == "mesonic"

  attr_accessible :billing_method, :billing_name, :billing_detail, :billing_street, :billing_postalcode,
                  :billing_city, :billing_country, :shipping_method, :shipping_name, :shipping_detail,
                  :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country,
                  :lineitems, :user, :user_id, :erp_customer_number, :erp_billing_number, :erp_order_number,
                  :billing_c_o, :shipping_c_o, :confirmation

  attr_accessor :confirmation, :type => :boolean

  has_paper_trail

  belongs_to :user, :creator => true
  view_hints.parent :user
  validates :user, :presence => true

  belongs_to :conversation

  has_many :lineitems, dependent: :destroy, accessible: true

  # --- Lifecycles --- #

  lifecycle do
    state :basket, :default => true
    state :ordered, :parked, :archived_basket, :accepted_offer
    state :paid, :shipped

    create :from_offer, :available_to => :all, become: :accepted_offer, params: [:user_id]

    transition :order, {:basket => :ordered}
    transition :payment, {:ordered => :paid}
    transition :shippment, {:paid => :shipped}, available_to: "User.administrator", subsite: "admin"

    transition :cash_payment, {:basket => :basket}, available_to: :user, if: "billing_method !='cash_payment' && shipping_method == 'pickup_shipment' " do
      self.update(billing_method: "cash_payment")
    end
    transition :cash_payment, {:accepted_offer => :accepted_offer}, available_to: :user, if: "billing_method !='cash_payment' && shipping_method == 'pickup_shipment' " do
      self.update(billing_method: "cash_payment")
    end

    transition :atm_payment, {:basket => :basket}, available_to: :user, if: "billing_method !='atm_payment' && shipping_method == 'pickup_shipment'" do
      self.update(billing_method: "atm_payment")
    end
    transition :atm_payment, {:accepted_offer => :accepted_offer}, available_to: :user, if: "billing_method !='atm_payment' && shipping_method == 'pickup_shipment'" do
      self.update(billing_method: "atm_payment")
    end

    transition :pre_payment, {:basket => :basket}, available_to: :user, if: "billing_method !='pre_payment'" do
      self.update(billing_method: "pre_payment")
    end
    transition :pre_payment, {:accepted_offer => :accepted_offer}, available_to: :user, if: "billing_method !='pre_payment'" do
      self.update(billing_method: "pre_payment")
    end

    transition :e_payment, {:basket => :basket}, available_to: :user, if: "billing_method !='e_payment'" do
      self.update(billing_method: "e_payment")
    end
    transition :e_payment, {:accepted_offer => :accepted_offer}, available_to: :user, if: "billing_method !='e_payment'" do
      self.update(billing_method: "e_payment")
    end


    transition :check_basket, {:basket => :basket}, available_to: :user, if: "acting_user.gtc_accepted_current? && billing_name && shipping_method"
    transition :check_basket, {:accepted_offer => :accepted_offer}, available_to: :user, if: "acting_user.gtc_accepted_current? && billing_name && shipping_method"

    transition :place, {:basket => :ordered}, available_to: :user, if: "acting_user.gtc_accepted_current? && billing_name"
    transition :place, {:accepted_offer => :ordered}, available_to: :user, if: "acting_user.gtc_accepted_current? && billing_name"

    transition :park, {:basket => :parked}, available_to: :user

    transition :archive_parked_basket, {:parked => :archived_basket}, available_to: :user

    transition :pickup_shipment, {:basket => :basket}, available_to: :user, if: "shipping_method != 'pickup_shipment'" do
      self.update(shipping_method: "pickup_shipment")

      shippment_costs_line = self.lineitems.where(position: 10000, product_number: "shipping", description_de: "Versandkosten").first
      shippment_costs_line.delete if shippment_costs_line
    end

    transition :pickup_shipment, {:accepted_offer => :accepted_offer}, available_to: :user, if: "shipping_method != 'pickup_shipment'" do
      self.update(shipping_method: "pickup_shipment")

      shippment_costs_line = self.lineitems.where(position: 10000, product_number: "shipping", description_de: "Versandkosten").first
      shippment_costs_line.delete if shippment_costs_line
    end

    transition :parcel_service_shipment, {:basket => :basket}, available_to: :user, if: "shipping_method != 'parcel_service_shipment'" do
      self.update(shipping_method: "parcel_service_shipment")
      self.update(billing_method: "e_payment") if ["atm_payment", "cash_payment"].include?(self.billing_method)
      self.add_shipment_costs
    end

    transition :parcel_service_shipment, {:accepted_offer => :accepted_offer}, available_to: :user, if: "shipping_method != 'parcel_service_shipment'" do
      self.update(shipping_method: "parcel_service_shipment")
      self.update(billing_method: "e_payment") if ["atm_payment", "cash_payment"].include?(self.billing_method)
      self.add_shipment_costs
    end

    transition :delete_all_positions, {:basket => :basket}, available_to: :user, if: "lineitems.any?" do
      lineitems.each do |lineitem|
        lineitem.delete
      end
    end
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.sales? ||
    (user_is? acting_user)
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales? ||
    user_is?(acting_user)
  end

  # --- Instance Methods --- #

  def basket?
    self.state == "basket"
  end

  def accepted_offer?
    self.state == "accepted_offer"
  end

  def sum
    self.lineitems.sum('value')
  end

  def vat_items
    vat_items = Hash.new
    grouped_lineitems = self.lineitems.group_by{|lineitem| lineitem.vat}
    grouped_lineitems.each_pair do |percentage, itemgroup|
      vat_items[percentage] = itemgroup.reduce(0) {|sum, lineitem| sum + lineitem.calculate_vat_value}
    end
    return vat_items
  end

  def sum_incl_vat
    self.sum + self.lineitems.*.calculate_vat_value.sum
  end

  def name
    if ["basket", "parked"].include?(state)
      "Warenkorb vom " + I18n.l(created_at).to_s
    else
      "Bestellung vom " + I18n.l(created_at).to_s
    end
  end

  def add_product(product: nil, amount: 1)
    if lineitem = self.lineitems.where(product_number: product.number, state: "active").first
      lineitem.increase_amount(amount: amount)
    else
      last_position = self.lineitems.*.position.max || 0
      Lineitem.create_from_product(order_id: self.id, product: product, amount: amount,
                                   position: last_position + 10, user_id: self.user_id)
    end
  end

  def merge(basket: nil)
    if basket.id !=id #first run or second run?
      positions_merged = "merged" if lineitems.present? && basket.lineitems.present?
      basket.lineitems.each do |lineitem|
        duplicate = self.lineitems.where(product_id: lineitem.product_id).first
        if duplicate.present?
          duplicate.merge(lineitem: lineitem)
        else
          lineitem.update(order_id: id)
        end
      end

      # Saving the latest confirmmation of GTC
      if basket.gtc_version_of && basket.gtc_version_of > self.gtc_version_of
        self.update(gtc_version_of: basket.gtc_version_of,
                    gtc_confirmed_at: basket.gtc_confirmed_at)
      end

      basket.delete
      return positions_merged
    end
  end

  def billing_address_filled?
    # all obligatory fields in billing address are filled?
    self.billing_name && self.billing_street &&  self.billing_postalcode &&
    self.billing_city && self.billing_country
  end

  def add_shipment_costs
    if Rails.application.config.erp == "mesonic" && acting_user.erp_account_nr
      webartikel_versandspesen = MercatorMesonic::Webartikel.where(Artikelnummer: "VERSANDSPESEN")
      shipping_cost_value = webartikel_versandspesen.mesonic_price(customer_id: acting_user.id) # user-specific derivation
      shipping_cost_value ||= webartikel_versandspesen.preis # non user-specific derivation

      Lineitem::Lifecycle.insert_shipping(acting_user, order_id: self.id,
                                                       user_id: acting_user.id,
                                                       position: 10000,
                                                       product_number: "VERSANDSPESEN",
                                                       description_de: "Versandkostenanteil",
                                                       amount: 1,
                                                       unit: "Pau.",
                                                       product_price: shipping_cost_value,
                                                       vat: webartikel_versandspesen.Steuersatzzeile * 10 ,
                                                       value: shipping_cost_value)
    else
      shipping_cost = ShippingCost.determine(order: self, shipping_method: "parcel_service_shipment")

      Lineitem::Lifecycle.insert_shipping(acting_user, order_id: self.id,
                                                       user_id: acting_user.id,
                                                       position: 10000,
                                                       product_number: "VERSANDSPESEN",
                                                       description_de: "Versandkostenanteil",
                                                       amount: 1,
                                                       unit: "Pau.",
                                                       product_price: shipping_cost.value,
                                                       vat: shipping_cost.vat,
                                                       value: shipping_cost.value)
    end
  end

  #--- Class Methods --- #

  def self.cleanup_deprecated
    JobLogger.info("=" * 50)
    JobLogger.info("Starting Cronjob runner: Order.cleanup_deprecated")

    Order.all.each do |basket|
      if basket.lineitems.count == 0 && Time.now - basket.created_at > 1.hours
        if basket.delete
          JobLogger.info("Deleted order " + basket.id.to_s + " successfully.")
        else
          JobLogger.error("Deleted order " + basket.id.to_s + " failed!")
        end
      end
    end

    JobLogger.info("Finished Cronjob runner: Order.cleanup_deprecated")
    JobLogger.info("=" * 50)
  end
end