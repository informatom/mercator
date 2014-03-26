class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name             :string, :required
    email_address    :email_address, :required, :unique, login: true
    administrator    :boolean, default: false
    sales            :boolean, default: false
    sales_manager    :boolean, default: false
    legacy_id        :integer
    last_login_at    :datetime
    logged_in        :boolean, default: false
    login_count      :integer, default: 0
    gtc_confirmed_at :datetime
    gtc_version_of   :date
    erp_account_nr   :string
    erp_contact_nr   :string
    timestamps
  end

  attr_accessible :name, :email_address, :password, :password_confirmation,
                  :current_password, :administrator, :legacy_id, :sales, :sales_manager,
                  :logged_in, :last_login_at, :login_count, :addresses, :billing_addresses,
                  :conversations, :confirmation, :photo

  if CONFIG[:mesonic] == "on"
    attr_accessible :mesonic_kontakte_stamm, :mesonic_kontenstamm, :mesonic_kontenstamm_fakt,
                    :mesonic_kontenstamm_fibu, :mesonic_kontenstamm_adresse
  end

  attr_accessor :confirmation

  has_paper_trail

  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  has_many :addresses, dependent: :destroy, inverse_of: :user, accessible: true
  has_many :billing_addresses, dependent: :destroy, inverse_of: :user, accessible: true

  has_many :orders, dependent: :restrict_with_exception, inverse_of: :user
  has_many :offers, dependent: :restrict_with_exception, inverse_of: :user

  has_many :conversations, dependent: :destroy, inverse_of: :customer, foreign_key: :customer_id

  if CONFIG[:mesonic] == "on"
    belongs_to :mesonic_kontakte_stamm, class_name: "MercatorMesonic::KontakteStamm", foreign_key: :erp_account_nr

    belongs_to :mesonic_kontenstamm, class_name: "MercatorMesonic::Kontenstamm", foreign_key: :erp_account_nr
    accepts_nested_attributes_for :mesonic_kontenstamm, allow_destroy: false

    belongs_to :mesonic_kontenstamm_fakt, class_name: "MercatorMesonic::KontenstammFakt", foreign_key: :erp_account_nr
    accepts_nested_attributes_for :mesonic_kontenstamm_fakt, allow_destroy: false

    belongs_to :mesonic_kontenstamm_fibu, class_name: "MercatorMesonic::KontenstammFibu", foreign_key: :erp_account_nr
    accepts_nested_attributes_for :mesonic_kontenstamm_fibu, allow_destroy: false

    belongs_to :mesonic_kontenstamm_adresse, class_name: "MercatorMesonic::KontenstammAdresse", foreign_key: :erp_account_nr
    accepts_nested_attributes_for :mesonic_kontenstamm_adresse, allow_destroy: false
  end

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
    state :guest, :active

    create :signup, :available_to => "Guest",
      params: [:name, :email_address, :password, :password_confirmation],
      become: :inactive, new_key: true  do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :create_key, {:inactive => :guest}, available_to: :all, new_key: true

    transition :accept_gtc, {:active => :active}, available_to: :self,
               params: [:confirmation], unless: :gtc_accepted_current?

    transition :accept_gtc, {:guest => :guest}, available_to: :self,
               params: [:confirmation], unless: :gtc_accepted_current?

    transition :activate, {:inactive => :active}, available_to: :key_holder

    transition :deactivate, {active: :inactive}, available_to: "User.administrator",
               subsite: "admin"
    transition :reactivate, {inactive: :active}, available_to: "User.administrator",
               subsite: "admin"

    transition :request_password_reset, {:inactive => :inactive}, new_key: true do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :request_password_reset, {[:active, :guest] => :active}, new_key: true do
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :reset_password, {:active => :active}, available_to: :key_holder,
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
    acting_user.sales? ||
    (acting_user == self &&
     only_changed?(:name, :email_address, :crypted_password, :current_password, :password,
                   :password_confirmation, :confirm))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    self == acting_user ||
    acting_user.sales? ||
    lifecycle.provided_key ||
    new_record? ||
    ( self.sales? && field == :name ) ||
    ( self.administrator? && field == :name )
  end

  #--- Instance Methods ---#

  def gtc_accepted_current?
    self.gtc_version_of == Gtc.current
  end

  def basket
    Order.user_is(self).basket.first
  end

  def sync_agb_with_basket
      # If user has already confirmed ...
      if self.gtc_version_of == Gtc.current
        self.basket.update(gtc_version_of:   Gtc.current,
                           gtc_confirmed_at: self.gtc_confirmed_at)
      end

      # If user had confirmed, when he was guest ...
      if self.gtc_version_of == Gtc.current
         self.update(gtc_version_of:   Gtc.current,
                     gtc_confirmed_at: self.basket.gtc_confirmed_at)
      end
  end

  def push_to_mesonic
    @timestamp = Time.now

    @kontonummer    = MercatorMesonic::Kontenstamm.next_kontonummer
    @kontaktenummer = MercatorMesonic::KontakteStamm.next_kontaktenummer

    @mesonic_kontakte_stamm = MercatorMesonic::KontakteStamm.initialize_mesonic(user: self, kontonummer: @kontonummer, kontaktenummer: @kontaktenummer)
    @mesonic_kontenstamm  = MercatorMesonic::Kontenstamm.initialize_mesonic(user: self, kontonummer: @kontonummer, timestamp: @timestamp)
    @mesonic_kontenstamm_fakt = MercatorMesonic::KontenstammFakt.initialize_mesonic(kontonummer: @kontonummer)
    @mesonic_kontenstamm_fibu = MercatorMesonic::KontenstammFibu.initialize_mesonic(kontonummer: @kontonummer)
    @mesonic_kontenstamm_adresse =  MercatorMesonic::KontenstammAdresse.initialize_mesonic(billing_address: self.billing_addresses.first, kontonummer: @kontonummer)

    if [@mesonic_kontakte_stamm, @mesonic_kontenstamm, @mesonic_kontenstamm_adresse,
        @mesonic_kontenstamm_fibu, @mesonic_kontenstamm_fakt ].collect(&:valid?).all?

    # HAS 20140325 Not yet connected to production system, uncomment for persisting erp user date
    #  [@mesonic_kontakte_stamm, @mesonic_kontenstamm, @mesonic_kontenstamm_adresse,
    #    @mesonic_kontenstamm_fibu, @mesonic_kontenstamm_fakt ].collect(&:save?).all?
    end

    self.update(erp_account_nr: User.mesoprim(number: @kontonummer),
                erp_contact_nr: User.mesoprim(number: @kontaktenummer) )
  end

  #--- Class Methods --- #

  def self.initialize()
    new_user = self.create(name: "Gast", email_address: Time.now.to_f.to_s + "@mercator.informatom.com")
    new_user.lifecycle.create_key!(new_user)
    return new_user
  end

  def self.assign_consultant()
    consultant = User.sales.where(logged_in: true).first
    return consultant
  end

  def self.mesoprim(number: nil)
    [number.to_s, MercatorMesonic::AktMandant.mesocomp, MercatorMesonic::AktMandant.mesoyear].join("-") if CONFIG[:mesonic] == "on"
  end
end