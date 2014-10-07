class Offeritem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string
    description_de :string, :required
    description_en :string
    amount         :decimal, :precision => 10, :scale => 2
    unit           :string
    product_price  :decimal, :scale => 2, :precision => 10
    vat            :decimal, :precision => 10, :scale => 2
    value          :decimal, :scale => 2, :precision => 10
    delivery_time  :string
    upselling      :boolean
    discount_abs   :decimal, :required, :scale => 2, :precision => 10, :default => 0
    timestamps
  end
  attr_accessible :position, :product_id, :product_number, :description_de, :description_en, :amount,
                  :unit, :product_price, :vat, :value, :delivery_time, :offer_id, :user_id, :selected, :discount_abs
  attr_accessor :selected, :boolean
  translates :description
  has_paper_trail
  default_scope { order('offeritems.position ASC') }

  validates :position, numericality: { only_integer: true }
  validates :amount, numericality: true
  validates :product_price, numericality: true
  validates :vat, numericality: true
  validates :value, numericality: true

  belongs_to :user
  belongs_to :offer
  validates :offer, :presence => true
  acts_as_list :scope => :offer

  belongs_to :product

  # --- Lifecycles --- #

  lifecycle do
    state :in_progress, :default => true

    create :add, :available_to => "User.sales", become: :in_progress,
           params: [:position, :product_id, :product_number, :description_de, :amount,
                    :unit, :product_price, :vat, :value, :offer_id, :user_id],
           subsite: "sales"

    transition :copy, {:in_progress => :in_progress}, available_to: :user,
               if: "Date.today <= offer.valid_until && offer.complete == false && offer.state == 'valid'"

    transition :delete_from_offer, {:in_progress => :in_progress}, available_to: "User.sales", subsite: "sales" do
      self.delete
    end
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def view_permitted?(field)
    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end

  # --- Instance Methods --- #

  def update_from_product(product_number: nil, amount: 1, discount_abs: 0)
    product = Product.find_by_number(product_number)

    if product
      price = product.determine_price(amount: amount, customer_id: user_id)
      inventory = product.determine_inventory(amount: amount)
      vat = inventory.determine_vat(amount: amount)
      update(product_id:     product.id,
             product_number: product.number,
             description_de: product.title_de,
             description_en: product.title_en,
             delivery_time:  product.delivery_time,
             unit:           inventory.unit,
             product_price:  price,
             vat:            vat)
      self.value = calculate_value
      save
    else
      update(product_id:     nil,
             product_number: product_number,
             delivery_time:  nil)
    end
  end

  def calculate_vat_value(discount_rel: 0)
    vat * value * ( 100 - discount_rel) / 100 / 100
  end

  def calculate_value(discount_abs: self.discount_abs)
    (product_price - discount_abs) * amount
  end
end
