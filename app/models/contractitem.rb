class Contractitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string
    description_de :string, :required
    description_en :string
    amount         :integer
    unit           :string
    product_price  :decimal, :precision => 10, :scale => 2
    vat            :decimal, :precision => 10, :scale => 2
    value          :decimal, :precision => 10, :scale => 2
    discount_abs   :decimal, :required, :scale => 2, :precision => 10, :default => 0
    timestamps
  end
  attr_accessible :position, :product_number, :description_de, :description_en, :amount, :unit,
                  :product_price, :vat, :value, :discount_abs, :user, :user_id, :contract_id, :contract,
                  :product, :product_id, :toner, :toner_id

  translates :description
  has_paper_trail
  default_scope { order('contractitems.position ASC') }

  validates :position, numericality: { only_integer: true }
  validates :amount, numericality: true
  validates :product_price, numericality: true
  validates :vat, numericality: true
  validates :value, numericality: true

  belongs_to :user
  belongs_to :contract
  validates :contract, :presence => true
  acts_as_list :scope => :contract

  belongs_to :product
  belongs_to :toner

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