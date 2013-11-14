class Supplyrelation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  attr_accessible :product, :product_id, :supply, :supply_id

  belongs_to :product
  belongs_to :supply, :class_name => 'Product', :foreign_key => 'supply_id'

  validates :product, :presence => true
  validates :supply_id, :presence => true, :uniqueness => {:scope => :product_id}

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
