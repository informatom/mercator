class Link < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    url   :string
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

# --- Class Methods --- #

  def local?
    if url.split("/")[2] == Constant::CMSDOMAIN ||  url.split("/")[2] == Constant::SHOPDOMAIN
      return true
    else
      return false
    end
  end

  def no_suggestion?
    not /\/conversations\/\d*\/suggestions/.match(URI(url).path)
  end
end