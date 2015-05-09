class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  Gender = HoboFields::Types::EnumString.for(:male, :female, :no_info)
  EditorType = HoboFields::Types::EnumString.for("wysiwyg", "html")

  JOBUSER = self.find_by(surname: "Job User") if defined? User
  ROBOT   = self.find_by(surname: "Robot") if defined? User

  fields do
    gender           User::Gender
    title            :string
    first_name       :string
    surname          :string, :required
    email_address    :email_address, :required, :unique, login: true
    phone            :string
    administrator    :boolean, default: false
    sales            :boolean, default: false
    sales_manager    :boolean, default: false
    contentmanager   :boolean, default: false
    productmanager   :boolean, default: false
    legacy_id        :integer
    last_login_at    :datetime
    logged_in        :boolean, default: false
    login_count      :integer, default: 0
    gtc_confirmed_at :datetime
    gtc_version_of   :date
    erp_account_nr   :string, :index => true
    erp_contact_nr   :string
    locale           :string
    call_priority    :integer
    waiting          :boolean
    editor           EditorType
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/user_extensions.rb
  include UserExtensions if Rails.application.config.try(:erp) == "mesonic"

  attr_accessible :gender, :title, :first_name, :surname, :email_address, :password,
                  :password_confirmation, :current_password, :administrator, :legacy_id, :sales,
                  :sales_manager, :contentmanager, :productmanager, :logged_in, :last_login_at,
                  :login_count, :addresses, :billing_addresses, :conversations, :confirmation,
                  :photo, :erp_account_nr, :erp_contact_nr, :order_id, :phone, :locale, :editor,
                  :waiting

  attr_accessor :confirmation, :type => :boolean
  attr_accessor :order_id, :type => :integer

  has_paper_trail

  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_many :addresses, dependent: :restrict_with_error, inverse_of: :user, accessible: true
  has_many :billing_addresses, dependent: :restrict_with_error, inverse_of: :user, accessible: true

  has_many :orders, dependent: :restrict_with_error, inverse_of: :user
  has_many :offers, dependent: :restrict_with_error, inverse_of: :user

  has_many :comments, dependent: :restrict_with_error, inverse_of: :user

  has_many :conversations, dependent: :restrict_with_error, inverse_of: :customer, foreign_key: :customer_id

  include Gravtastic
  gravtastic :default => "http://www.informatom.com/assets/images/unknown-user.png"
  gravtastic :email_address

  # --- Signup lifecycle --- #

  lifecycle do

    state :inactive, default: true
    state :guest, :active

    create :signup, :available_to => "Guest",
      params: [:gender, :title, :first_name, :surname, :email_address, :phone, :password, :password_confirmation],
      become: :inactive, new_key: true  do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :create_key, {:inactive => :guest}, available_to: :all, new_key: true
    transition :create_key, {:guest => :active}, available_to: :all, new_key: true
    transition :create_key, {:active => :active}, available_to: :all, new_key: true

    transition :accept_gtc, {:active => :active}, available_to: :self,
               params: [:confirmation, :order_id], unless: :gtc_accepted_current?

    transition :accept_gtc, {:guest => :guest}, available_to: :self,
               params: [:confirmation, :order_id], unless: :gtc_accepted_current?

    transition :activate, {:inactive => :active}, available_to: :key_holder
    transition :activate, {:guest => :active}, available_to: :key_holder

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

    transition :reset_password, {:active => :active}, available_to: :all,
               params: [ :password, :password_confirmation ], unless: :crypted_password

    transition :login_via_email, {:active => :active},
               available_to: :key_holder, if: "Time.now() - self.key_timestamp < 10.minutes"
  end

  def signed_up?
    state=="active"
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.sales? ||
    (acting_user == self &&
     only_changed?(:gender, :title, :first_name, :surname, :email_address, :phone,
                   :crypted_password, :current_password, :password, :password_confirmation,
                   :confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change,
    # it cannot be changed directly from a form submission.
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
    ( sales? && ( field == :first_name || field == :surname ) ) ||
    ( administrator? && ( field == :first_name || field == :surname ) )
  end

  #--- Instance Methods ---#

  def name
    name = [title, first_name, surname].join " "
    if gender && gender != "no_info"
      name = I18n.t("activerecord.attributes.user/genders."+ gender) + " " + name
    end
    return name
  end

  def gtc_accepted_current?
    gtc_version_of == Gtc.current
  end

  def basket
    Order.find_by(user_id: id, state: :basket) or Order.create(user_id: id)
  end

  def parked_basket
    parked_baskets = orders.parked

    # A bit of cleanup here...
    if parked_baskets.any?
      parked_baskets.each do |parked_basket|
        parked_basket.delete_if_obsolete
      end
    end

    parked_baskets = orders.parked
    return parked_baskets.last
  end

  def sync_agb_with_basket
      # If user has already confirmed ...
      if gtc_version_of == Gtc.current
        basket.update(gtc_version_of:   Gtc.current,
                      gtc_confirmed_at: gtc_confirmed_at)
      end

      # If user had confirmed, when he was guest ...
      if gtc_version_of == Gtc.current
         update(gtc_version_of:   Gtc.current,
                gtc_confirmed_at: basket.gtc_confirmed_at)
      end
  end

  def call_for_chat_partner(locale: nil)
    I18n.locale = locale

    [0, 1, 2, 3, 4].each do |attempt|
      consultant = User.assign_consultant(position: attempt)
      break unless consultant

      message = I18n.t('mercator.salutation.new_video_chat')

      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/personal/"+ consultant.id.to_s,
                            sender: User::ROBOT.name,
                            content: message,
                            video_channel_id: id)
      sleep 5
      self.reload
      return unless waiting
    end

    self.reload
    if waiting
      message = Message.create(reciever_id: id,
                               sender: User::ROBOT,
                               content: I18n.t('mercator.salutation.sorry'))

      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/personal/"+ id.to_s,
                            sender: message.sender.name,
                            content: message.content)
    end
  end

  #--- Class Methods --- #

  def self.initialize()
    new_user = create(surname: "Gast",
                      email_address: Time.now.to_f.to_s + "@mercator.informatom.com")
    new_user.lifecycle.create_key!(new_user)
    return new_user
  end

  def self.assign_consultant(position: 0)
    available_consultants = User.sales.where(logged_in: true).order(:call_priority)
    return nil unless available_consultants.any?

    consultant = available_consultants[position.modulo(available_consultants.count)]
    return consultant
  end

  def self.mesoprim(number: nil)
    if Rails.application.config.try(:erp) == "mesonic"
      [number.to_s, MercatorMesonic::AktMandant.mesocomp, MercatorMesonic::AktMandant.mesoyear].join("-")
    end
  end

  def self.cleanup_deprecated
    JobLogger.info("=" * 50)
    JobLogger.info("Starting Cronjob runner: User.cleanup_deprecated")

    User.all.each do |user|
      if user.orders.count == 0 &&
         Time.now - user.created_at > 1.hours &&
         user.surname == "Gast" &&
         user.state == "guest" &&
         user.gtc_confirmed_at == nil
        if user.destroy
          JobLogger.info("Deleted User " + user.id.to_s + " successfully.")
        else
          JobLogger.error("Deleted User " + user.id.to_s + " failed!")
        end
      end
    end

    JobLogger.info("Finished Cronjob runner: User.cleanup_deprecated")
    JobLogger.info("=" * 50)
  end

  def self.no_sales_logged_in
    unless User.assign_consultant
      UserMailer.consultant_missing.deliver
    end
  end
end