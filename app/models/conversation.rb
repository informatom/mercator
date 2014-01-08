class Conversation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :text, :required
    timestamps
  end
  attr_accessible :name, :customer_id, :consultant_id, :customer, :consultant
  has_paper_trail

  belongs_to :customer, :class_name => 'User'
  belongs_to :consultant, :class_name => 'User'

  validates :customer, :presence => true
  validates :consultant, :presence => true

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
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
