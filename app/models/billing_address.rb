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
  validates :user_id, :presence => true, :uniqueness => true

  # --- Permissions --- #

  def create_permitted?
    acting_user.billing_addresses.count == 0
  end

  def update_permitted?
    acting_user.administrator? || acting_user.sales? || user_is?(acting_user)
  end

  def destroy_permitted?
    acting_user.administrator? || acting_user.sales? || user_is?(acting_user)
  end

  def view_permitted?(field)
    acting_user.administrator? || acting_user.sales? || user_is?(acting_user)
  end
end