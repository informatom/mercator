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

  # --- Lifecycle --- #

  lifecycle do
    state :active, default: true

    create :enter, :available_to => :all, become: :active,
      params: [:name, :detail, :street, :postalcode, :city, :country],
      if: :gtc_current

    transition :use, {:active => :active}, :available_to => :user
    transition :trash, {:active => :active}, :available_to => :user
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    # The user is not allowed to change his/her billing address deliberately
    # acting_user.billing_addresses.count == 0 ||
    acting_user.administrator? ||
    acting_user.sales?
  end

  def destroy_permitted?
    # user_is?(acting_user) ||
    acting_user.administrator? ||
    acting_user.sales?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales? ||
    user_is?(acting_user) ||
    new_record?
  end

  #--- Instance Methods ---#

  def gtc_current
    acting_user.gtc_accepted_current?
  end
end