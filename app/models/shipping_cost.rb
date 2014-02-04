class ShippingCost < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    shipping_method :string, :required
    value           :decimal, :required, :precision => 10, :scale => 2
    timestamps
  end
  attr_accessible :country, :shipping_method, :value, :country_id

  has_paper_trail
  belongs_to :country

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
