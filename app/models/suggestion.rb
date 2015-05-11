class Suggestion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  attr_accessible :product_id, :conversation_id, :product, :conversation

  has_paper_trail

  belongs_to :conversation
  validates :conversation, :presence => true

  belongs_to :product
  validates :product, :presence => true

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
    acting_user.administrator? ||
    acting_user.sales? ||
    conversation.customer_is?(acting_user)
  end

# --- Instance methods --- #

  def name
    # strangely otherwise the product name completer fails in conversation
    product ? "(" + product.number.to_s + ") " + product.title : ""
  end
end
