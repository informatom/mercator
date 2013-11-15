class Country < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, :required, :unique
    code :string, :required, :unique
    timestamps
  end
  attr_accessible :name, :code
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
