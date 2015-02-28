class Download < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, :required
    timestamps
  end
  attr_accessible :name, :document, :conversation_id, :conversation, :document, :photo
  has_paper_trail

  has_attached_file :document, :default_url => "/file/:style/missing.png"
  has_attached_file :photo, :default_url => "/images/:style/missing.png",
                    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" }

  do_not_validate_attachment_file_type :document
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  belongs_to :conversation
  validates :conversation, :presence => true

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