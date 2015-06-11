class Address < ActiveRecord::Base

  hobo_model # Don't put anything above this

  Gender = HoboFields::Types::EnumString.for(:male, :female, :no_info)

  fields do
    company    :string, :required
    gender     Address::Gender
    title      :string
    first_name :string, :required
    surname    :string, :required, :name => true
    detail     :string
    street     :string, :required
    postalcode :string, :required
    city       :string, :required
    country    :string, :required
    phone      :string
    timestamps
  end

  attr_accessible :gender, :title, :first_name, :surname, :company,
                  :detail, :street, :postalcode, :city, :country, :phone
  attr_accessor :order_id, :type => :integer
  has_paper_trail

  belongs_to :user, :creator => true
  validates :user, :presence => true

  validate :if_country_exists

  # --- Lifecycle --- #

  lifecycle do
    state :active, default: true

    create :enter, :available_to => :all, become: :active,
           params: [:company, :gender, :title, :first_name, :surname, :detail,
                    :street, :postalcode, :city, :country, :phone, :order_id]

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

  #--- Instance Methods ---#

  def if_country_exists
    unless Country.find_by_name(country)
      errors.add(:base, "Unbekanntes Land")
    end
  end


  def name
    surname + ", " + city
  end
end