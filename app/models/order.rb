class Order < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billing_method      :string
    billing_gender      :string
    billing_title       :string
    billing_first_name  :string
    billing_surname     :string
    billing_company     :string
    billing_detail      :string
    billing_street      :string
    billing_postalcode  :string
    billing_city        :string
    billing_country     :string
    billing_phone       :string
    shipping_method     :string
    shipping_gender     :string
    shipping_title      :string
    shipping_first_name :string
    shipping_surname    :string
    shipping_company    :string
    shipping_detail     :string
    shipping_street     :string
    shipping_postalcode :string
    shipping_city       :string
    shipping_country    :string
    shipping_phone      :string
    store               :string
    gtc_confirmed_at    :datetime
    gtc_version_of      :date
    erp_customer_number :string
    erp_billing_number  :string
    erp_order_number    :string
    discount_rel        :decimal, :required, :precision => 13, :scale => 5, :default => 0
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/order_extensions.rb
  if Constant.table_exists? && Rails.application.config.try(:erp) == "mesonic"
    include OrderExtensions
  end

  # can be found in mercator/vendor/engines/mercator_mpay24/app/models/order_extensions.rb
  if Constant.table_exists? && Rails.application.config.try(:payment) == "mpay24"
    include Mpay24OrderExtensions
  end

  attr_accessible :billing_method, :billing_company,:billing_gender, :billing_title,
                  :billing_first_name, :billing_surname, :billing_detail, :billing_street,
                  :billing_postalcode, :billing_city, :billing_country, :shipping_method,
                  :shipping_company, :shipping_gender, :shipping_title, :shipping_first_name,
                  :shipping_surname, :shipping_detail, :shipping_street, :shipping_postalcode,
                  :shipping_city, :shipping_country, :lineitems, :user, :user_id,
                  :erp_customer_number, :erp_billing_number, :erp_order_number, :confirmation,
                  :discount_rel, :billing_phone, :shipping_phone, :store

  attr_accessor :confirmation, :type => :boolean

  has_paper_trail

  belongs_to :user, :creator => true, inverse_of: :orders
  view_hints.parent :user
  validates :user, :presence => true

  belongs_to :conversation

  has_many :lineitems, dependent: :restrict_with_error, accessible: true

  DEFAULT_BILLING_METHOD =
    Rails.application.config.try(:payment) == "mpay24" ? :e_payment : :pre_payment

  DEFAULT_SHIPPING_METHOD =
    Rails.application.config.try(:payment) == "mpay24" ? :parcel_service_shipment : :pickup_shipment



  # --- Lifecycles --- #

  lifecycle do
    state :basket, :default => true
    state :ordered, :parked, :archived_basket, :accepted_offer
    state :paid, :shipped, :in_payment, :payment_failed

    create :from_offer, :available_to => :all, become: :accepted_offer,
           params: [:user_id, :billing_company, :billing_phone, :billing_gender, :billing_title,
                    :billing_first_name, :billing_surname, :billing_detail, :billing_street,
                    :billing_postalcode, :billing_city, :billing_country, :shipping_company,
                    :shipping_phone, :shipping_gender, :shipping_title, :shipping_first_name,
                    :shipping_surname, :shipping_detail, :shipping_street, :shipping_postalcode,
                    :shipping_city, :shipping_country, :discount_rel, :billing_method]

    transition :shippment, {:paid => :shipped}, available_to: "User.administrator", subsite: "admin"


    transition :cash_payment, {:basket => :basket}, available_to: :user,
               if: "billing_method !='cash_payment' && shipping_method == 'pickup_shipment' " do
      self.update(billing_method: "cash_payment")
    end
    transition :cash_payment, {:accepted_offer => :accepted_offer}, available_to: :user,
               if: "billing_method !='cash_payment' && shipping_method == 'pickup_shipment' " do
      self.update(billing_method: "cash_payment")
    end
    transition :cash_payment, {:payment_failed => :payment_failed}, available_to: :user,
               if: "billing_method !='cash_payment' && shipping_method == 'pickup_shipment' " do
      self.update(billing_method: "cash_payment")
    end

    transition :atm_payment, {:basket => :basket}, available_to: :user,
               if: "billing_method !='atm_payment' && shipping_method == 'pickup_shipment'" do
      self.update(billing_method: "atm_payment")
    end
    transition :atm_payment, {:accepted_offer => :accepted_offer}, available_to: :user,
               if: "billing_method !='atm_payment' && shipping_method == 'pickup_shipment'" do
      self.update(billing_method: "atm_payment")
    end
    transition :atm_payment, {:payment_failed => :payment_failed}, available_to: :user,
               if: "billing_method !='atm_payment' && shipping_method == 'pickup_shipment'" do
      self.update(billing_method: "atm_payment")
    end


    transition :pre_payment, {:basket => :basket}, available_to: :user,
               if: "billing_method !='pre_payment'" do
      self.update(billing_method: "pre_payment")
    end
    transition :pre_payment, {:accepted_offer => :accepted_offer}, available_to: :user,
               if: "billing_method !='pre_payment'" do
      self.update(billing_method: "pre_payment")
    end
    transition :pre_payment, {:payment_failed => :payment_failed}, available_to: :user,
               if: "billing_method !='pre_payment'" do
      self.update(billing_method: "pre_payment")
    end

    transition :e_payment, {:basket => :basket}, available_to: :user,
               if: "billing_method !='e_payment' && Rails.application.config.try(:payment) == 'mpay24'" do
      self.update(billing_method: "e_payment")
    end
    transition :e_payment, {:accepted_offer => :accepted_offer}, available_to: :user,
               if: "billing_method !='e_payment' && Rails.application.config.try(:payment) == 'mpay24'" do
      self.update(billing_method: "e_payment")
    end
    transition :e_payment, {:payment_failed => :payment_failed}, available_to: :user,
               if: "billing_method !='e_payment' && Rails.application.config.try(:payment) == 'mpay24'" do
      self.update(billing_method: "e_payment")
    end




    transition :check, {:basket => :basket}, available_to: :user,
               if: "acting_user.gtc_accepted_current? && billing_address_filled? && shipping_method.present?"
    transition :check, {:accepted_offer => :accepted_offer}, available_to: :user,
               if: "acting_user.gtc_accepted_current? && billing_address_filled? && shipping_method.present?"
    transition :check, {:in_payment => :in_payment}, available_to: :user,
               if: "acting_user.gtc_accepted_current? && billing_address_filled? && shipping_method.present?"


    transition :place, {[:basket, :accepted_offer] => :ordered}, available_to: :user,
               if: "acting_user.gtc_accepted_current? && billing_address_filled? && billing_method !='e_payment'"

    transition :pay, {[:basket, :accepted_offer, :in_payment, :payment_failed] => :in_payment}, available_to: :user,
               if: "acting_user.gtc_accepted_current? && billing_address_filled? && billing_method =='e_payment'"


    transition :failing_payment, {[:in_payment, :payment_failed, :paid] => :payment_failed},
               available_to: "User.find_by(surname: 'MPay24')"

    transition :successful_payment, {[:in_payment, :payment_failed, :paid] => :paid},
               available_to: "User.find_by(surname: 'MPay24')"


    transition :park, {:basket => :parked}, available_to: :user

    transition :archive_parked_basket, {:parked => :archived_basket}, available_to: :user

    transition :pickup_shipment, {:basket => :basket}, available_to: :user,
               if: "shipping_method != 'pickup_shipment'" do
      self.update(shipping_method: "pickup_shipment")
      self.lineitems
          .find_by(product_number: Constant.find_by_key("shipping_cost_article").value)
          .try(:destroy)
    end

    transition :pickup_shipment, {:accepted_offer => :accepted_offer},
               available_to: :user, if: "shipping_method != 'pickup_shipment'" do
      self.update(shipping_method: "pickup_shipment")
      self.lineitems
          .find_by(product_number: Constant.find_by_key("shipping_cost_article").value)
          .try(:destroy)
    end

    transition :parcel_service_shipment, {:basket => :basket},
               available_to: :user, if: "shipping_method != 'parcel_service_shipment' && self.shippable?" do
      self.update(shipping_method: "parcel_service_shipment")
      if ["atm_payment", "cash_payment"].include?(billing_method)
        self.update(billing_method: Order::DEFAULT_BILLING_METHOD)
      end
      self.add_shipment_costs
    end

    transition :parcel_service_shipment, {:accepted_offer => :accepted_offer},
               available_to: :user, if: "shipping_method != 'parcel_service_shipment' && self.shippable?" do
      self.update(shipping_method: "parcel_service_shipment")
      if ["atm_payment", "cash_payment"].include?(billing_method)
        self.update(billing_method: Order::DEFAULT_BILLING_METHOD)
      end
      self.add_shipment_costs
    end


    transition :delete_all_positions, {:basket => :basket}, available_to: :user,
               if: "lineitems.any?" do
      lineitems.destroy_all
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


  def shippable?
    !lineitems.*.product.*.try(:not_shippable).any?
  end


  def accepted_offer?
    self.state == "accepted_offer"
  end


  def sum
    self.lineitems.sum('value') - self.discount
  end


  def discount
    self.discount_rel = 0 unless discount_rel
    lineitems.any? ? discount_rel * lineitems.sum('value') / 100 : 0
  end


  def vat
    lineitems.*.vat_value(discount_rel: discount_rel).sum
  end


  def sum_incl_vat
    if lineitems.any?
      sum + vat
    else
      0
    end
  end


  def vat_items
    vat_items = Hash.new
    grouped_lineitems = lineitems.group_by{|lineitem| lineitem.vat}
    grouped_lineitems.each_pair do |percentage, itemgroup|
      vat_items[percentage] = itemgroup.reduce(0) do |sum, lineitem|
        sum + lineitem.vat_value(discount_rel: discount_rel)
      end
    end
    return vat_items
  end


  def name
    if ["basket", "parked"].include?(state)
      [I18n.t("attributes.basket"), I18n.t("mercator.from"),I18n.l(created_at).to_s].join(" ").html_safe
    else
      [I18n.t("activerecord.models.order.one"), I18n.t("mercator.from"), I18n.l(created_at).to_s].join(" ").html_safe
    end
  end


  def add_product(product: nil, amount: 1)
    if lineitem = lineitems.where(product_id: product.id, state: "active").first
      lineitem.increase_amount(amount: amount)
    else
      last_position = lineitems.*.position.max || 0
      Lineitem.create_from_product(order_id: id, product: product, amount: amount,
                                   position: last_position + 10, user_id: user_id)
    end
  end


  def add_inventory(inventory: nil, amount: 1)
    if lineitem = lineitems.where(inventory_id: inventory.id, state: "active").first
      lineitem.increase_amount(amount: amount)
    else
      last_position = lineitems.*.position.max || 0
      Lineitem.create_from_inventory(order_id: id, inventory: inventory, amount: amount,
                                     position: last_position + 10, user_id: user_id)
    end
  end


  def merge(basket: nil)
    # This method is deprecated...
    if basket.id != id #first run or second run?
      positions_merged = "merged" if lineitems.present? && basket.lineitems.present?
      basket.lineitems.each do |lineitem|
        duplicate = lineitems.where(product_id: lineitem.product_id, inventory_id: lineitem.inventory_id).first

        if duplicate.present?
          duplicate.merge(lineitem: lineitem)
        else
          lineitem.update(order_id: id)
        end
      end

      # Saving the latest confirmmation of GTC
      if basket.gtc_version_of && basket.gtc_version_of > gtc_version_of
        update(gtc_version_of:   basket.gtc_version_of,
               gtc_confirmed_at: basket.gtc_confirmed_at)
      end

      basket.reload # otherwise destroy in next line fails, if a lineitem has been moved over
      basket.destroy
      return positions_merged
    end
  end


  def billing_address_filled?
    # all obligatory fields in billing address are filled?
    if billing_surname && billing_street &&  billing_postalcode && billing_city && billing_country
      return true
    else
      return false
    end
  end


  def add_shipment_costs
    shipping_cost_product_number = Constant.find_by_key("shipping_cost_article").value

    self.lineitems
        .find_by(product_number: shipping_cost_product_number)
        .try(:destroy)

    @user = acting_user || self.user

    if Rails.application.config.try(:erp) == "mesonic"
      webartikel_versandspesen = MercatorMesonic::Webartikel.where(Artikelnummer: shipping_cost_product_number).first
      inventory_versandspesen = Inventory.where(number: shipping_cost_product_number).first
      product_versandspesen = inventory_versandspesen.product

      # user-specific derivation
      shipping_cost_value = inventory_versandspesen.mesonic_price(customer_id: @user.id)
      # non user-specific derivation
      shipping_cost_value ||= webartikel_versandspesen.Preis

      Lineitem::Lifecycle.insert_shipping(@user,
                                          order_id:       id,
                                          user_id:        @user.id,
                                          position:       10000,
                                          product_number: shipping_cost_product_number,
                                          description_de: "Versandkostenanteil",
                                          description_en: "Shipping Costs",
                                          amount:         1,
                                          unit:           "Pau.",
                                          product_price:  shipping_cost_value,
                                          vat:            webartikel_versandspesen.Steuersatzzeile * 10 ,
                                          value:          shipping_cost_value,
                                          product_id:     product_versandspesen.id)
    else
      shipping_cost = ShippingCost.determine(order: self, shipping_method: "parcel_service_shipment")

      Lineitem::Lifecycle.insert_shipping(@user,
                                          order_id:       id,
                                          user_id:        @user.id,
                                          position:       10000,
                                          product_number: shipping_cost_product_number,
                                          description_de: "Versandkostenanteil",
                                          description_en: "Shipping Costs",
                                          amount:         1,
                                          unit:          "Pau.",
                                          product_price: shipping_cost.value,
                                          vat:           shipping_cost.vat,
                                          value:         shipping_cost.value)
    end
  end


  def shipping_cost
    shipping_cost_product_number = Constant.find_by_key("shipping_cost_article").value
    shipping_cost_item = lineitems.find_by(product_number: shipping_cost_product_number)
    shipping_cost_item ? shipping_cost_item.value : 0
  end


  def shipping_cost_vat
    shipping_cost_product_number = Constant.find_by_key("shipping_cost_article").value
    shipping_cost_item = lineitems.find_by(product_number: shipping_cost_product_number)
    shipping_cost_item ? shipping_cost_item.vat : 0
  end


  def delete_if_obsolete
    case lineitems.count
    when 0 # empty?
      destroy ? 1 : -1
    when 1 # only shipping cost?
      if lineitems[0].product_number == Constant.find_by_key("shipping_cost_article").value
        lineitems[0].destroy
        self.reload
        destroy ? 1 : -1
      else
        0
      end
    else
      0
    end
  end


  #--- Class Methods --- #

  def self.cleanup_deprecated
    JobLogger.info("=" * 50)
    JobLogger.info("Starting Cronjob runner: Order.cleanup_deprecated")

    count = 0
    Order.all.each do |basket|
      if Time.now - basket.created_at > 1.hours
        deletion_count = basket.delete_if_obsolete
        if deletion_count == 1
          count = count + 1
        elsif deletion_count == -1
          JobLogger.error("Deleting order " + basket.id.to_s + " failed!")
        end
      end
    end

    JobLogger.info("Deleted " + count.to_s + " orders.")
    JobLogger.info("Finished Cronjob runner: Order.cleanup_deprecated")
    JobLogger.info("=" * 50)
  end


  def self.notify_in_payment
    @orders = Order.where(state: :in_payment, updated_at: (Time.now - 1.day)..Time.now)
    OrderMailer.notify_in_payment(@orders).deliver_now if @orders.any?
  end
end