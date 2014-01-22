class Lineitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string, :required
    description_de :string, :required
    description_en :string
    amount         :decimal, :required, :precision => 10, :scale => 2
    unit           :string, :required
    product_price  :decimal, :required, :scale => 2, :precision => 10
    vat            :decimal, :required, :precision => 10, :scale => 2
    value          :decimal, :required, :scale => 2, :precision => 10
    timestamps
  end

  attr_accessible :position, :product_number, :description_de, :description_en, :unit,
                  :amount, :product_price, :product_price, :vat, :value,
                  :value, :order_id, :order, :user_id, :product_id
  translates :description
  has_paper_trail
  default_scope { order('lineitems.position ASC') }

  validates :position, numericality: true
  validates :amount, numericality: true
  validates :product_price, numericality: true
  validates :vat, numericality: true
  validates :value, numericality: true
  # validates :product_number, :uniqueness => {:scope => :order_id}

  belongs_to :user, :creator => true

  belongs_to :order
  validates :order, :presence => true
  acts_as_list :scope => :order

  belongs_to :product

  lifecycle do
    state :active, :default => true

    transition :delete_from_basket, {:active => :active}, if: "acting_user.basket == self.order",
                available_to: :all do
      self.delete
    end

    transition :add_one, {:active => :active}, if: "acting_user.basket == self.order",
               available_to: :all do
      amount = self.amount + 1
      price = product.price(amount: amount)
      self.update_attributes(amount:        amount,
                             product_price: price,
                             value:         price * amount)
    end

    transition :remove_one, {:active => :active}, if: "acting_user.basket == self.order",
               available_to: :all do
      if amount == 1
        self.delete
      else
        amount = self.amount - 1
        price = product.price(amount: amount)
        self.update_attributes(amount:        amount,
                               product_price: price,
                               value:         price * amount)
      end
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

#--- Instace methods ---#

  def increase_amount(amount: 1)
    self.amount += amount

    product = Product.find(self.product_id)
    self.value = product.price(amount: self.amount)
    raise unless self.save
  end

  def merge(lineitem: nil)
    increase_amount(amount: lineitem.amount)
    lineitem.delete
  end

  #--- Class Methods --- #

  def self.create_from_product(user_id: nil, product: nil, amount: 1, position:nil, order_id: nil)
    price = product.price(amount: amount)
    lineitem = Lineitem.new(user_id:        user_id,
                            order_id:       order_id,
                            position:       position,
                            product_id:     product.id,
                            product_number: product.number,
                            description_de: product.name_de,
                            description_en: product.name_en,
                            amount:         amount,
                            unit:           product.inventories.first.unit,
                            product_price:  price,
                            vat:            product.inventories.first.prices.first.vat,
                            value:          amount * price )

    raise unless lineitem.save
  end

end