class Constant < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    key   :string
    value :string
    timestamps
  end
  attr_accessible :key, :value

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
