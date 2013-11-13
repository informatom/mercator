class Lineitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string, :required
    description_de :string, :required
    description_en :string
    amount         :integer, :required
    product_price  :decimal, :required, :scale => 2, :precision => 10
    vat            :integer, :required
    value          :decimal, :required, :scale => 2, :precision => 10
    timestamps
  end

  # validates :product_number, :uniqueness => {:scope => :order}

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
    ( acting_user == self.user ) || acting_user.administrator?
  end
end