class Conversation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, :required
    timestamps
  end
  attr_accessible :name, :customer_id, :consultant_id, :customer, :consultant,
                  :downloads, :messages, :offers, :baskets, :user, :content, :mode
  has_paper_trail
  attr_accessor :content, :type => :text
  attr_accessor :mode, :type => :text

  belongs_to :customer, class_name: 'User', inverse_of: :conversations
  belongs_to :consultant, :class_name => 'User'

  validates :customer, :presence => true

  has_many :downloads
  has_many :messages
  has_many :links
  has_many :offers
  has_many :baskets, -> {where state: "basket"}, :class_name => 'Order'
  has_many :products, :through => :suggestions
  has_many :suggestions

  # --- Lifecycles --- #

  lifecycle do
    state :active, default: true

    create :initiate, become: :active, available_to: :all, new_key: true, params: [:name]
    transition :upload, {:active => :active}, available_to: :collaborators, subsite: "sales"
    transition :feedback, {:active => :active}, available_to: :customer, params: [:content, :mode]
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator?
    acting_user.sales? ||
    customer_is?(acting_user)
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales? ||
    customer_is?(acting_user) ||
    new_record?
  end

  #--- Instance Methods ---#

  def collaborators
    [consultant, customer]
  end

  def last_link
    links.recent(1)[0]
  end

  def inform_sales(locale: :en)
    I18n.locale = locale

    [0, 1, 2, 3, 4].each do |attempt|
      consultant = User.assign_consultant(position: attempt)
      break unless consultant
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/personal/"+ consultant.id.to_s,
                            sender: User.robot.name,
                            content: I18n.t('mercator.salutation.new_conversation'),
                            conversation: id)
      sleep 5
      self.reload
      return if consultant_id
    end

    self.reload
    unless consultant_id
      message = Message.create(conversation_id: id,
                               reciever: customer,
                               sender: User.robot,
                               content: I18n.t('mercator.salutation.sorry'))

      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ id.to_s,
                            type: "messages")

      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/personal/"+ message.reciever_id.to_s,
                            sender: message.sender.name,
                            content: message.content)
    end
  end
end