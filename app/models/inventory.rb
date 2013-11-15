class Inventory < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de    :string, :required
    name_en    :string
    number     :string, :required, :unique
    amount     :decimal, :required
    unit       :string, :required
    comment_de :string
    comment_en :string
    weight     :decimal
    charge     :string
    storage    :string
    timestamps
  end
  attr_accessible :name_de, :name_en, :number, :amount, :unit,
                  :comment_de, :comment_en, :weight, :charge, :storage,
                  :product, :product_id
  translates :name, :description
  has_paper_trail

  belongs_to :product
  validates :product, :presence => true

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
