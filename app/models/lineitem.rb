class Lineitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string,  :required
    description_de :string, :required
    description_en :string
    amount         :decimal, :required, :precision => 10, :scale => 2
    unit           :string, :required
    product_price  :decimal, :required, :scale => 2, :precision => 10
    vat            :decimal, :required, :precision => 10, :scale => 2
    value          :decimal, :required, :scale => 2, :precision => 10
    delivery_time  :string
    upselling      :boolean
    discount_abs   :decimal, :required, :scale => 2, :precision => 10, :default => 0
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

  belongs_to :user, :creator => true

  belongs_to :order
  validates :order, :presence => true

  acts_as_list :scope => :order

  belongs_to :product

  lifecycle do
    state :active, :default => true
    state :shipping_costs, :blocked

    create :insert_shipping, :available_to => :all, become: :shipping_costs,
           params: [:position, :product_number, :product_id, :offer_id, :description_de, :amount, :unit, :product_price, :vat, :value, :order_id, :user_id, :delivery_time]

    create :from_offeritem, :available_to => :all, become: :active,
           params: [:position, :product_number, :product_id, :offer_id, :description_de,
                    :description_en, :amount, :unit, :product_price, :vat, :discount_abs,
                    :value, :order_id, :user_id, :delivery_time]

    create :blocked_from_offeritem, :available_to => :all, become: :blocked,
           params: [:position, :product_number, :product_id, :offer_id, :description_de,
                    :description_en, :amount, :unit, :product_price, :vat, :discount_abs,
                    :value, :order_id, :user_id, :delivery_time]

    transition :delete_from_basket, {:active => :active}, if: "acting_user.basket == order", available_to: :all do
      self.delete
    end

    transition :transfer_to_basket, {:active => :active}, if: "acting_user == order.user", available_to: :all do
      self.update(order: acting_user.basket)
    end

    transition :enable_upselling, {:active => :active},
                                  if: "acting_user.basket == order && !upselling && product.supplies.any?",
                                  available_to: :all do
      self.update(upselling: true)
    end

    transition :enable_upselling, {:blocked => :blocked},
                                  if: "acting_user.basket == order && !upselling && product_number && product.supplies.any?",
                                  available_to: :all do
      self.update(upselling: true)
    end

    transition :disable_upselling, {:active => :active}, if: "acting_user.basket == order && upselling", available_to: :all do
      self.update(upselling: false)
    end

    transition :disable_upselling, {:blocked => :blocked}, if: "acting_user.basket == order && upselling", available_to: :all do
      self.update(upselling: false)
    end

    transition :add_one, {:active => :active}, if: "acting_user.basket == order",
               available_to: :all do
      amount = self.amount + 1
      price = product.determine_price(amount: amount, customer_id: self.user.id)
      self.update(amount: amount,
                  product_price: price)
      self.update(value: self.calculate_value)
      PrivatePub.publish_to("/orders/"+ acting_user.basket.id.to_s, type: "basket")
    end

    transition :remove_one, {:active => :active}, if: "acting_user.basket == order",
               available_to: :all do
      if amount == 1
        self.delete
      else
        amount = self.amount - 1
        price = product.determine_price(amount: amount, customer_id: self.user.id)
        self.update(amount:        amount,
                    product_price: price)
        self.update(value: self.calculate_value)
      end
      PrivatePub.publish_to("/orders/"+ acting_user.basket.id.to_s, type: "basket")
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

  def increase_amount(amount: 1)
    self.amount += amount

    product = Product.find(self.product_id)
    self.value = product.price(amount: self.amount) * self.amount
    raise unless self.save
  end

  def merge(lineitem: nil)
    increase_amount(amount: lineitem.amount)
    lineitem.delete
  end

  def calculate_vat_value(discount_rel: 0)
    self.vat * self.value * ( 100 - discount_rel) / 100 / 100
  end

  def calculate_value(discount_abs: self.discount_abs)
    (self.product_price - discount_abs) * self.amount
  end

  #--- Class Methods --- #

  def self.create_from_product(user_id: nil, product: nil, amount: 1, position:nil, order_id: nil)
    price = product.determine_price(amount: amount, customer_id: user_id)
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
                            product_price:  price,
                            vat:            vat)
    lineitem.value = lineitem.calculate_value

    unless lineitem.save
      raise "Lineitem connot be created"
    end
  end
end