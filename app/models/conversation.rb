class Conversation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, :required
    timestamps
  end
  attr_accessible :name, :customer_id, :consultant_id, :customer, :consultant,
                  :downloads, :messages, :offers, :baskets, :user
  has_paper_trail

  belongs_to :customer, class_name: 'User', inverse_of: :conversations
  belongs_to :consultant, :class_name => 'User'

  validates :customer, :presence => true
  validates :consultant, :presence => true

  has_many :downloads
  has_many :messages
  has_many :offers, -> {where state: :offer}, :class_name => 'Order'
  has_many :baskets, -> {where state: "basket"}, :class_name => 'Order'

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
