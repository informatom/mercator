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

# --- Class Methods --- #

  def local?
    @cms_domain = Constant.find_by_key("cms_domain").try(:value)
    @shop_domain = Constant.find_by_key("shop_domain").try(:value)
    if url.split("/")[2] == @cms_domain ||  url.split("/")[2] == @shop_domain
      return true
    else
      return false
    end
  end
end