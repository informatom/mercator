class Constant < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    key   :string, :required, :unique
    value :string
    timestamps
  end
  attr_accessible :key, :value

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
