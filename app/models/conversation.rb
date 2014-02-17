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

  validates :consultant, :presence => true
  validates :customer, :presence => true

  has_many :downloads
  has_many :messages
  has_many :offers, -> {where state: :offer}, :class_name => 'Order'
  has_many :baskets, -> {where state: "basket"}, :class_name => 'Order'

  # --- Lifecycles --- #

  lifecycle do
    state :active, default: true

    create :initiate, become: :active, available_to: :all, new_key: true, params: [:name]
    transition :upload, {:active => :active}, available_to: :collaborators, subsite: "admin"
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
    customer_is?(acting_user)
  end

  #--- Instance Methods ---#

  def collaborators
    [self.consultant, self.customer]
  end
end
