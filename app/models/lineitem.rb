class Lineitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer
    product_number :string
    description_de :string
    description_en :string
    amount         :integer
    product_price  :decimal, :scale => 2, :precision => 10
    vat            :integer
    value          :decimal, :scale => 2, :precision => 10
    timestamps
  end
  attr_accessible :position, :product_number, :description_de, :description_en,
                  :amount, :product_price, :product_price, :vat, :value, :value

  translates :description

  has_paper_trail

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
    true
  end

end
