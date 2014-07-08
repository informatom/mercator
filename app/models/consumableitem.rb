class Consumableitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position        :integer
    product_number  :string
    product_line    :string
    description_de  :string
    description_en  :string
    amount          :integer
    theyield        :integer
    wholesale_price :decimal, :precision => 10, :scale => 2
    term            :integer
    consumption1    :integer
    consumption2    :integer
    consumption3    :integer
    consumption4    :integer
    consumption5    :integer
    consumption6    :integer
    balance6        :decimal, :precision => 10, :scale => 2
    timestamps
  end
  attr_accessible :position, :product_number, :product_line, :description_de, :description_en, :amount, :theyield, :wholesale_price, :term, :consumption1, :consumption2, :consumption3, :consumption4, :consumption5, :consumption6, :balance6

  belongs_to :contractitem
  validates :contractitem, :presence => true

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
    acting_user.sales? ||
    acting_user.administrator?
  end
end