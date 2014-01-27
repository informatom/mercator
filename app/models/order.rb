class Order < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billing_method      :string
    billing_name        :string
    billing_detail      :string
    billing_street      :string
    billing_postalcode  :string
    billing_city        :string
    billing_country     :string
    shipping_method     :string
    shipping_name       :string
    shipping_detail     :string
    shipping_street     :string
    shipping_postalcode :string
    shipping_city       :string
    shipping_country    :string
    gtc_confirmed_at    :datetime
    gtc_version_of      :date
    timestamps
  end

  attr_accessible :billing_method, :billing_name, :billing_detail, :billing_street, :billing_postalcode,
                  :billing_city, :billing_country, :shipping_method, :shipping_name, :shipping_detail,
                  :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country,
                  :lineitems, :user, :user_id
  has_paper_trail

  belongs_to :user, :creator => true
  view_hints.parent :user

  belongs_to :conversation

  has_many :lineitems, dependent: :destroy, accessible: true

  validates :user, :presence => true

  # --- Lifecycles --- #

  lifecycle do
    state :basket, :default => true
    state :ordered, :paid, :shipped, :offer

    transition :order, {[:basket, :offer] => :ordered}
    transition :payment, {:ordered => :paid}
    transition :shippment, {:paid => :shipped}, available_to: "User.administrator", subsite: "admin"

    transition :cash_payment, {:basket => :basket}, available_to: :user, if: "self.shipping_name && self.billing_method !='cash' " do
      self.update(billing_method: "cash_payment", shipping_method: "pickup_shipment")
    end
    transition :atm_payment, {:basket => :basket}, available_to: :user, if: "self.shipping_name && self.billing_method !='atm'"do
      self.update(billing_method: "atm_payment", shipping_method: "pickup_shipment")
    end
    transition :pre_payment, {:basket => :basket}, available_to: :user, if: "self.shipping_name && self.billing_method !='pre'"do
      self.update(billing_method: "pre_payment", shipping_method: nil)
    end
    transition :e_payment, {:basket => :basket}, available_to: :user, if: "self.shipping_name && self.billing_method !='e'"do
      self.update(billing_method: "e_payment", shipping_method: nil)
    end

    transition :pickup_shipment, {:basket => :basket}, available_to: :user, if: :may_change_to_pickup_shipment do
      self.update(shipping_method: "pickup_shipment")
    end
    transition :parcel_service_shipment, {:basket => :basket}, available_to: :user, if: :may_change_to_parcel_service_shipment do
      self.update(shipping_method: "parcel_service_shipment")
    end
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator? ||
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

  def name
    "Bestellung vom " + I18n.l(created_at).to_s
  end

  def add_product(product: nil, amount: 1)
    if lineitem = self.lineitems.where(product_number: product.number).first
      lineitem.increase_amount(amount: amount)
    else
      Lineitem.create_from_product(order_id: self.id, product: product, amount: amount,
                                   position: self.lineitems.count + 1, user_id: self.user_id)
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
      if basket.gtc_version_of > self.gtc_version_of
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

  def may_change_to_pickup_shipment
    self.shipping_method !='pickup' && may_select_shipment
  end

  def may_change_to_parcel_service_shipment
    self.shipping_method !='parcel_service' && may_select_shipment
  end

  def may_select_shipment
    ["pre_payment", "e_payment"].include?(self.billing_method)
  end


  #--- Class Methods --- #

  def self.cleanup_deprecated
    puts "\n" + I18n.l(Time.now).to_s + " Starting Job cleanup orders"
    Order.basket.all.each do |basket|
      if basket.lineitems.count == 0 && basket.conversation.nil? && Time.now - basket.created_at > 1.hours
        puts "  deleting order " + basket.id.to_s
        basket.delete
      end
    end
    puts I18n.l(Time.now).to_s + " Finished Job cleanup orders"
  end
end