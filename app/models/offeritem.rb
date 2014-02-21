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
    timestamps
  end
  attr_accessible :position, :product_id, :product_number, :description_de, :description_en, :amount,
                  :unit, :product_price, :vat, :value, :delivery_time, :offer_id, :user_id
  translates :description
  has_paper_trail
  default_scope { order('offeritems.position ASC') }

  validates :position, numericality: true
  validates :amount, numericality: true
  validates :product_price, numericality: true
  validates :vat, numericality: true
  validates :value, numericality: true

  belongs_to :user
  belongs_to :offer
  validates :offer, :presence => true
  acts_as_list :scope => :offer

  belongs_to :product

  lifecycle do
    state :in_progress, :default => true

    create :add, :available_to => "User.sales", become: :in_progress,
           params: [:position, :product_id, :product_number, :description_de, :amount,
                    :unit, :product_price, :vat, :value, :offer_id, :user_id],
           subsite: "sales"

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

  def update_from_product(product_number: nil, amount: 1)
    product = Product.find_by_number(product_number)
    if product
      price = product.price(amount: amount)
      self.update(product_id:     product.id,
                  product_number: product.number,
                  description_de: product.title_de,
                  description_en: product.title_en,
                  delivery_time:  product.delivery_time,
                  unit:           product.inventories.first.unit,
                  product_price:  price,
                  vat:            product.inventories.first.prices.first.vat,
                  value:          amount * price )
    else
      self.update(product_id:     nil,
                  product_number: product_number,
                  delivery_time:  nil)
    end
  end

  def vat_value
    self.vat * self.value / 100
  end
end
