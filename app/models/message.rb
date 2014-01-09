class Message < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    content :string, :required
    timestamps
  end
  attr_accessible :content, :sender_id, :sender, :reciever_id, :reciever, 
                  :conversation_id, :conversation
  has_paper_trail

  belongs_to :sender, :class_name => 'User'
  belongs_to :reciever, :class_name => 'User'
  belongs_to :conversation

  validates :sender, :presence => true
  validates :reciever, :presence => true

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
