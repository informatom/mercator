class Address < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name       :string, :required
    c_o           :string
    detail     :string
    street     :string, :required
    postalcode :string, :required
    city       :string, :required
    country    :string, :required
    timestamps
  end

  attr_accessible :user_id, :name, :detail, :street, :postalcode,
                  :city, :user, :country, :c_o, :order_id
  attr_accessor :order_id, :type => :integer
  has_paper_trail

  belongs_to :user, :creator => true
  validates :user, :presence => true

  validate :if_country_exists

  # --- Lifecycle --- #

  lifecycle do
    state :active, default: true

    create :enter, :available_to => :all, become: :active,
      params: [:name, :detail, :c_o, :street, :postalcode, :city, :country, :order_id]

    transition :use, {:active => :active}, :available_to => :user
    transition :trash, {:active => :active}, :available_to => :user
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

  #--- Class Methods ---#

  def if_country_exists
    errors.add(:base, "Unbekanntes Land") unless Country.find_by_name(self.country)
  end
end