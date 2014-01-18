class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name             :string, :required
    email_address    :email_address, :required, :unique, login: true
    administrator    :boolean, default: false
    sales            :boolean, default: false
    legacy_id        :integer
    last_login_at    :datetime
    logged_in        :boolean, default: false
    login_count      :integer, default: 0
    timestamps
  end

  attr_accessible :name, :email_address, :password, :password_confirmation,
                  :current_password, :administrator, :legacy_id, :sales,
                  :logged_in, :last_login_at, :login_count, :addresses, :billing_addresses,
                  :conversations
  has_paper_trail

  has_many :addresses, dependent: :destroy, inverse_of: :user, accessible: true
  has_many :billing_addresses, dependent: :destroy, inverse_of: :user, accessible: true

  has_many :orders, dependent: :restrict_with_exception, inverse_of: :user

  has_many :conversations, dependent: :destroy, inverse_of: :customer, foreign_key: :customer_id

  # This gives admin rights and an :active state to the first sign-up.
  # Just remove it if you don't want that
  before_create do |user|
    if !Rails.env.test? && user.class.count == 0
      user.administrator = true
      user.state = "active"
    end
  end


  # --- Signup lifecycle --- #

  lifecycle do

    state :inactive, default: true
    state :active

    create :signup, :available_to => "Guest",
      params: [:name, :email_address, :password, :password_confirmation],
      become: :inactive, new_key: true  do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :activate, { inactive: :active }, :available_to => :key_holder

    transition :deactivate, { active: :inactive }, :available_to => "User.administrator",
               :subsite => "admin"


    transition :request_password_reset, { inactive: :inactive }, :new_key => true do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :request_password_reset, { active: :active }, :new_key => true do
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :reset_password, { active: :active }, :available_to => :key_holder,
               params: [ :password, :password_confirmation ]
  end

  def signed_up?
    state=="active"
  end

  # --- Permissions --- #

  def create_permitted?
    # Only the initial admin user can be created
    self.class.count == 0 || acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator? ||
    (acting_user == self &&
     only_changed?(:name, :email_address, :crypted_password, :current_password, :password,
                   :password_confirmation, :addresses, :billing_addresses))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? || self == acting_user || acting_user.sales? || lifecycle.provided_key || new_record?
  end

  def basket
    Order.user_is(self).basket.first
  end
end