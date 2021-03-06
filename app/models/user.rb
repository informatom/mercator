class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  Gender = HoboFields::Types::EnumString.for(:male, :female, :no_info)
  EditorType = HoboFields::Types::EnumString.for("wysiwyg", "html")

  fields do
    gender           Gender
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

  if User.table_exists? # enable initial schema loading
    JOBUSER = self.find_by(surname: "Job User")
    ROBOT   = self.find_by(surname: "Robot")
  end

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/user_extensions.rb
  include UserExtensions if Rails.application.config.try(:erp) == "mesonic"

  attr_accessible :gender, :title, :first_name, :surname, :email_address, :password,
                  :password_confirmation, :current_password, :administrator, :legacy_id, :sales,
                  :sales_manager, :contentmanager, :productmanager, :logged_in, :last_login_at,
                  :login_count, :addresses, :billing_addresses, :conversations, :confirmation,
                  :photo, :erp_account_nr, :erp_contact_nr, :order_id, :phone, :locale, :editor,
                  :waiting, :call_priority

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


  # --- Lifecycle --- #

  lifecycle do

    state :inactive, default: true
    state :guest, :active

    # HAS 20150608: We dont't need any direct signup, users are created automatically
    # create :signup, :available_to => "Guest",
    #   params: [:gender, :title, :first_name, :surname, :email_address, :phone, :password, :password_confirmation],
    #   become: :inactive, new_key: true  do
    #   UserMailer.activation(self, lifecycle.key).deliver_now
    # end


    transition :resend_email_confirmation, {[:inactive, :guest] => :inactive}, available_to: :all

    transition :accept_gtc, {:active => :active}, available_to: :self,
               params: [:confirmation, :order_id], unless: :gtc_accepted_current?

    transition :activate, {[:inactive, :guest] => :active}, available_to: :key_holder

    transition :deactivate, {active: :inactive}, available_to: "User.administrator",
               subsite: "admin"

    transition :reactivate, {inactive: :active}, available_to: "User.administrator",
               subsite: "admin"


    transition :request_password_reset, {:inactive => :inactive}, new_key: true do
      UserMailer.forgot_password(self, lifecycle.key).deliver_now
    end

    transition :request_password_reset, {[:active, :guest] => :active}, new_key: true do
      UserMailer.forgot_password(self, lifecycle.key).deliver_now
    end

    transition :reset_password, {:active => :active}, available_to: :key_holder,
               params: [ :password, :password_confirmation ]

    transition :reset_password, {:active => :active}, available_to: :all,
               params: [ :password, :password_confirmation ], unless: :crypted_password

    transition :reset_password, {:inactive => :inactive}, available_to: :all,
               params: [ :password, :password_confirmation ], unless: :crypted_password


    transition :login_via_email, {:active => :active}, available_to: :key_holder,
               if: "Time.now() - self.key_timestamp < 10.minutes"

    transition :login_via_email, {:inactive => :active}, available_to: :key_holder,
               if: "Time.now() - self.key_timestamp < 10.minutes"
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

  def signed_up?
    state == "active"
  end


  def name
    name = [title, first_name, surname].join " "
    if gender && gender != "no_info"
      name = I18n.t("activerecord.attributes.user/genders."+ gender) + " " + name
    end
    return name.squeeze(" ")
  end


  def gtc_accepted_current?
    gtc_version_of == Gtc.current
  end


  def basket
    Order.find_by(user_id: id, state: :basket) or Order.create(user_id: id)
  end


  def parked_basket
    # A bit of cleanup here...
    orders.parked.each do |basket|
      basket.delete_if_obsolete
    end

    orders.parked.last
  end


  def sync_agb_with_basket
    if basket.gtc_confirmed_at.present?
      if !basket.gtc_confirmed_at.present? || gtc_version_of > basket.gtc_confirmed_at
        # If user has already confirmed ...
        basket.update(gtc_version_of:   gtc_version_of,
                      gtc_confirmed_at: gtc_confirmed_at)
      end
    end

    if gtc_version_of.present?
      if !basket.gtc_version_of.present? || basket.gtc_version_of > gtc_version_of
        # If user had confirmed, when he was guest ...
        update(gtc_version_of:   basket.gtc_version_of,
               gtc_confirmed_at: basket.gtc_confirmed_at)
      end
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
      return "message sent"
    end
  end


  #--- Class Methods --- #

  def self.find_by_name(param)
    find_by_email_address(param)
  end

  def self.initialize()
    new_user = create(surname: "Gast",
                      email_address: Time.now.to_f.to_s + "@mercator.informatom.com")
    new_user.lifecycle.generate_key
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
    count = 0

    User.all.each do |user|
      if user.orders.count == 0 && user.addresses.count == 0 && user.billing_addresses.count == 0 &&
         user.offers.count == 0 && user.comments.count == 0 && user.conversations.count == 0 &&
         Time.now - user.created_at > 1.hours &&
         user.surname == "Gast" &&
         (user.state == "guest" || user.state == "inactive") &&
         user.gtc_confirmed_at == nil
        if user.destroy
          count = count + 1
        else
          JobLogger.error("Deleted User " + user.id.to_s + " failed:" + user.errors.first.to_s)
        end
      end
    end

    JobLogger.info("Deleted " + count.to_s + " users.")
    JobLogger.info("Finished Cronjob runner: User.cleanup_deprecated")
    JobLogger.info("=" * 50)
  end


  def self.no_sales_logged_in
    unless User.assign_consultant
      UserMailer.consultant_missing.deliver_now
    end
  end
end