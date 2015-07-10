class Contract < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    term      :integer, :required, :default => 0
    startdate :date
    timestamps
  end
  attr_accessible :runtime, :startdate, :user_id, :user_id, :consultant, :consultant_id,
                  :conversation, :conversation_id, :term,  :created_at, :updated_at,
                  :customer_id, :customer
  has_paper_trail

  belongs_to :customer, :class_name => 'User'
  belongs_to :consultant, :class_name => 'User'
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
#    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end


  # --- Instance Methods --- #

  def enddate
    if term
      startdate + term.months - 1.day
    else
      startdate
    end
  end
end