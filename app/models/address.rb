class Address < ActiveRecord::Base

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

  # --- Lifecycle --- #

  lifecycle do
    state :active, default: true

    create :enter, :available_to => :all, become: :active,
      params: [:name, :detail, :street, :postalcode, :city, :country],
      if: :basket_has_billing_address?
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.sales? ||
    user_is?(acting_user)
  end

  def destroy_permitted?
    acting_user.administrator? ||
    acting_user.sales? ||
    user_is?(acting_user)
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales? ||
    user_is?(acting_user) ||
    new_record?
  end

  #--- Instance Methods ---#

  def basket_has_billing_address?
    acting_user.basket.billing_address_filled?
  end
end