class Lineitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string, :required
    description_de :string, :required
    description_en :string
    amount         :decimal, :required
    unit           :string, :required
    product_price  :decimal, :required, :scale => 2, :precision => 10
    vat            :decimal, :required
    value          :decimal, :required, :scale => 2, :precision => 10
    timestamps
  end

  attr_accessible :position, :product_number, :description_de, :description_en,
                  :amount, :product_price, :product_price, :vat, :value, :value, :order_id, :order
  translates :description
  has_paper_trail

  belongs_to :order

  validates :order, :presence => true
  validates :product_number, :uniqueness => {:scope => :order_id}
  validates :position, :uniqueness => {:scope => :order_id}

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator?
  end
end