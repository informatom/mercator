class Category < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name     :string
    ancestry :string, :index => true
    position :integer
    active   :boolean
    timestamps
  end
  attr_accessible :name, :ancestry, :position, :active, :parent_id

  has_ancestry
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
