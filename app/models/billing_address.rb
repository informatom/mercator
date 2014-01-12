class BillingAddress < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name       :string, :required
    detail     :string
    street     :string, :required
    postalcode :string, :required
    city       :string, :required
    country    :string, :required
    timestamps
  end
  attr_accessible :user_id, :name, :detail, :street, :postalcode,
                  :city, :user, :country
  has_paper_trail

  belongs_to :user, :creator => true
  validates :user, :presence => true

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator? || acting_user.sales?
  end

  def destroy_permitted?
    acting_user.administrator? || acting_user.sales?
  end

  def view_permitted?(field)
    true
  end

end
