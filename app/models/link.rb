class Link < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    url   :string, :required
    title :string
    timestamps
  end
  attr_accessible :url, :title, :conversation_id
  has_paper_trail

  belongs_to :conversation

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator? ||
    acting_user.sales?
  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.sales?
  end

  def destroy_permitted?
    acting_user.administrator? ||
    acting_user.sales?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales? ||
    conversation.customer_is?(acting_user)
  end

end
