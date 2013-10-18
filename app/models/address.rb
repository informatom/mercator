class Address < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name       :string
    detail     :string
    street     :string
    postalcode :string
    city       :string
    timestamps
  end
  attr_accessible :user_id, :name, :detail, :street, :postalcode, :city, :user

  belongs_to :user
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
