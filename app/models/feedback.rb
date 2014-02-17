class Feedback < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    content :text, :required
    timestamps
  end
  attr_accessible :content, :user_id, :consultant_id, :conversation_id

  has_paper_trail
  belongs_to :user
  belongs_to :consultant, :class_name => 'User'
  belongs_to :conversation

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    false
  end

  def view_permitted?(field)
    acting_user.sales_manager?
  end
end