class BillingAddress < ActiveRecord::Base

  hobo_model # Don't put anything above this

  Gender = HoboFields::Types::EnumString.for(:male, :female, :no_info)

  fields do
    company       :string, :required
    gender        BillingAddress::Gender
    title         :string
    first_name    :string, :required
    surname       :string, :required, :name => true
    email_address :email_address, :required
    detail        :string
    street        :string, :required
    postalcode    :string, :required
    city          :string, :required
    country       :string, :required
    phone         :string
    vat_number    :string
    timestamps
  end

  attr_accessible :gender, :title, :first_name, :surname, :company,
                  :detail, :street, :postalcode, :city, :country, :phone, :email_address, :vat_number
  attr_accessor :order_id, :type => :integer
  has_paper_trail

  belongs_to :user, :creator => true
  validates :user, :presence => true

  validates :vat_number, :valvat => {:allow_blank => true}
  # Alternatively enforce validation:
  # validates :vat_number, :valvat => {:lookup => true}

  validate :if_country_exists

  # --- Lifecycle --- #

  lifecycle do
    state :active, default: true

    create :enter, :available_to => :all, become: :active,
      params: [:company, :gender, :title, :first_name, :surname, :detail, :street, :postalcode,
               :city, :country, :email_address, :phone, :vat_number, :order_id]

    transition :use, {:active => :active}, :available_to => :user, params: [:order_id]
    transition :trash, {:active => :active}, :available_to => :user
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    # Order matters, because user_is? causes
    # Hobo::UndefinedAccessError Exception: Hobo::UndefinedAccessError
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
    new_record? ||
    user_is?(acting_user)
  end

  #--- Instance Methods ---#

  def if_country_exists
    errors.add(:base, "Unbekanntes Land") unless Country.find_by_name(country)
  end
end