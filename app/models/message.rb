class Message < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    content :string, :required, :name => true
    timestamps
  end
  attr_accessible :content, :sender_id, :sender, :reciever_id, :reciever,
                  :conversation_id, :conversation
  has_paper_trail

  default_scope { order('messages.created_at DESC') }

  belongs_to :sender, :class_name => 'User'
  belongs_to :reciever, :class_name => 'User'
  belongs_to :conversation

  validates :sender, :presence => true


  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator? ||
    sender_is?(acting_user)
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales ||
    reciever_is?(acting_user) ||
    sender_is?(acting_user) ||
    new_record?
  end
end