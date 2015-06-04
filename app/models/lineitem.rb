class Lineitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string,  :required
    description_de :string, :required
    description_en :string
    amount         :decimal, :required, :precision => 10, :scale => 2
    unit           :string, :required
    product_price  :decimal, :required, :precision => 13, :scale => 5
    vat            :decimal, :required, :precision => 10, :scale => 2
    value          :decimal, :required, :precision => 13, :scale => 5
    delivery_time  :string
    upselling      :boolean
    discount_abs   :decimal, :required, :precision => 13, :scale => 5, :default => 0
    timestamps
  end

  attr_accessible :position, :product_number, :description_de, :description_en, :unit,
                  :amount, :product_price, :product_price, :vat, :value,
                  :value, :order_id, :order, :user_id, :product_id, :delivery_time
  translates :description
  has_paper_trail
  default_scope { order('lineitems.position ASC') }

  validates :position, numericality: { only_integer: true }
  validates :amount, numericality: :true
  validates :product_price, numericality: true
  validates :vat, numericality: true
  validates :value, numericality: true
  validates :discount_abs, numericality: :true

  belongs_to :user, :creator => true

  belongs_to :order
  validates :order, :presence => true

  acts_as_list :scope => :order

  belongs_to :product
  belongs_to :inventory


  # --- Lifecycle --- #

  lifecycle do
    state :active, :default => true
    state :shipping_costs, :blocked

    create :insert_shipping, :available_to => :all, become: :shipping_costs,
           params: [:position, :product_number, :product_id, :offer_id, :description_de,
                    :description_en, :amount, :unit, :product_price, :vat, :value,
                    :order_id, :user_id, :delivery_time]

    create :from_offeritem, :available_to => :all, become: :active,
           params: [:position, :product_number, :product_id, :offer_id, :description_de,
                    :description_en, :amount, :unit, :product_price, :vat, :discount_abs,
                    :value, :order_id, :user_id, :delivery_time]

    create :blocked_from_offeritem, :available_to => :all, become: :blocked,
           params: [:position, :product_number, :product_id, :offer_id, :description_de,
                    :description_en, :amount, :unit, :product_price, :vat, :discount_abs,
                    :value, :order_id, :user_id, :delivery_time]

    transition :delete_from_basket,
               {:active => :active},
               if: "acting_user.basket == order",
               available_to: :all do
      self.destroy
    end

    transition :transfer_to_basket,
               {:active => :active},
               if: "acting_user == order.user",
               available_to: :all do
      parked_basket = order
      self.update(order: acting_user.basket)
      parked_basket.delete_if_obsolete
    end

    transition :enable_upselling,
               {:active => :active},
               if: "acting_user.basket == order && !upselling && product && product.supplies.any?",
               available_to: :all do
      self.update(upselling: true)
    end

    transition :enable_upselling,
               {:blocked => :blocked},
               if: "acting_user.basket == order && !upselling && product && product.supplies.any?",
               available_to: :all do
      self.update(upselling: true)
    end

    transition :disable_upselling,
               {:active => :active},
               if: "acting_user.basket == order && upselling",
               available_to: :all do
      self.update(upselling: false)
    end

    transition :disable_upselling,
               {:blocked => :blocked},
               if: "acting_user.basket == order && upselling",
               available_to: :all do
      self.update(upselling: false)
    end

    transition :add_one, {:active => :active}, available_to: :all,
               if: "acting_user.basket == order" do
      self.increase_amount(customer_id: acting_user.id)
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/orders/"+ acting_user.basket.id.to_s,
                            type: "basket")
    end

    transition :remove_one, {:active => :active}, available_to: :all,
               if: "acting_user.basket == order" do
      if self.amount == 1
        self.destroy
      else
        self.increase_amount(customer_id: acting_user.id, amount: -1)
      end
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/orders/"+ acting_user.basket.id.to_s,
                            type: "basket")
    end
  end


  # --- Permissions --- #

  def create_permitted?
    true
  end


  def update_permitted?
    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end


  def destroy_permitted?
    user_is?(acting_user) ||
    acting_user.administrator?
  end


  def view_permitted?(field)
    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end


 #--- Instance methods ---#

  def increase_amount(customer_id: nil, amount: 1)
    self.update(amount: self.amount + amount)
    self.new_pricing
  end


  def new_pricing
    price =
      if self.inventory_id
        Inventory.find(inventory_id)
                 .determine_price(amount: amount,
                                  customer_id: user_id)
      else
        Product.find(product_id)
               .determine_price(amount: amount,
                                customer_id: user_id)
      end
    self.update(product_price: price)
    self.update(value: (product_price - discount_abs) * amount)
  end


  def merge(lineitem: nil)
    increase_amount(amount: lineitem.amount)
    lineitem.destroy
  end


  def vat_value(discount_rel: 0)
    self.vat * self.value * ( 100 - discount_rel) / 100 / 100
  end


  def value_incl_vat
    self.value * (100 + self.vat) / 100
  end


  def gross_price
    self.product_price * (100 + self.vat) / 100
  end


  def undiscounted_gross_value
    self.amount * self.product_price * (100 + self.vat) / 100
  end


  #--- Class Methods --- #

  def self.create_from_product(user_id: nil, product: nil, amount: 1, position:nil, order_id: nil)
    inventory = product.determine_inventory(amount: amount)
    vat = inventory.determine_vat(amount: amount)

    lineitem = Lineitem.new(user_id:        user_id,
                            order_id:       order_id,
                            position:       position,
                            product_id:     product.id,
                            product_number: product.number,
                            description_de: product.title_de,
                            description_en: product.title_en,
                            delivery_time:  product.delivery_time,
                            amount:         amount,
                            unit:           inventory.unit,
                            product_price:  1, # temporary
                            value:          1 * amount, # temporary
                            vat:            vat)

    unless lineitem.save
      raise "Lineitem connot be created: " + lineitem.errors.messages.to_s
    end

    lineitem.new_pricing
    return lineitem
  end


  def self.create_from_inventory(user_id: nil, inventory: nil, amount: 1, position: nil, order_id: nil)
    vat = inventory.determine_vat(amount: amount)
    product = inventory.product
    delivery_time = inventory.delivery_time || product.delivery_time

    lineitem = Lineitem.new(user_id:        user_id,
                            order_id:       order_id,
                            position:       position,
                            product_id:     product.id,
                            inventory_id:   inventory.id,
                            product_number: inventory.number,
                            description_de: product.title_de,
                            description_en: product.title_en,
                            delivery_time:  delivery_time,
                            amount:         amount,
                            unit:           inventory.unit,
                            product_price:  1, # temporary
                            value:          1 * amount, # temporary
                            vat:            vat)

    unless lineitem.save
      raise "Lineitem connot be created"
    end

    lineitem.new_pricing
    return lineitem
  end


  def self.cleanup_orphaned
    Lineitem.all.each do |lineitem|
      lineitem.destroy unless lineitem.order
    end
  end
end