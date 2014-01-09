class Download < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, :required
    timestamps
  end
  attr_accessible :name, :document, :conversation_id, :conversation, :document
  has_paper_trail

  has_attached_file :document, :default_url => "/images/:style/missing.png"

  belongs_to :conversation
  validates :conversation, :presence => true

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
