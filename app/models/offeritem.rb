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
  attr_accessible :position, :product_number, :description_de, :description_en, :unit,
                  :amount, :product_price, :product_price, :vat, :value,
                  :offer_id, :offer, :user_id, :product_id, :delivery_time
  translates :description
  has_paper_trail
  default_scope { order('lineitems.position ASC') }

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
    state :active, :default => true
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

end
