class Contract < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    runtime   :integer, :required
    startdate :date, :required
    timestamps
  end
  attr_accessible :runtime, :startdate, :user_id, :user_id, :consultant, :consultant_id,
                  :conversation, :conversation_id
  has_paper_trail

  belongs_to :customer, :class_name => 'User'
  validates :customer, :presence => true

  belongs_to :consultant, :class_name => 'User'
  validates :consultant, :presence => true

  belongs_to :conversation

  has_many :contractitems, dependent: :destroy, accessible: true

  # --- Permissions --- #

  def create_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def view_permitted?(field)
    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end
end