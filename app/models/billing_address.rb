class BillingAddress < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name          :string, :required
    c_o           :string
    email_address :email_address, :required
    detail        :string
    street        :string, :required
    postalcode    :string, :required
    city          :string, :required
    country       :string, :required
    vat_number    :string, :required
    timestamps
  end

  attr_accessible :user_id, :name, :detail, :street, :postalcode,
                  :city, :user, :country, :email_address, :vat_number, :c_o
  has_paper_trail

  belongs_to :user, :creator => true
  validates :user, :presence => true
  validates :vat_number, :valvat => {:lookup => true}

  # --- Lifecycle --- #

  lifecycle do
    state :active, default: true

    create :enter, :available_to => :all, become: :active,
      params: [:name, :detail, :c_o, :street, :postalcode, :city, :country, :email_address, :vat_number]

    transition :use, {:active => :active}, :available_to => :user
    transition :trash, {:active => :active}, :available_to => :user
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    user_is?(acting_user) ||
    acting_user.administrator? ||
    acting_user.sales?

  end

  def destroy_permitted?
    user_is?(acting_user) ||
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
end