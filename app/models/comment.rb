class Comment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    content  :text, :required
    ancestry :string, :index => true
    timestamps
  end
  attr_accessible :content, :ancestry, :blogpost, :blogpost_id, :user_id, :user,
                  :podcast_id, :podcast

  has_ancestry orphan_strategy: :adopt
  has_paper_trail
  never_show :ancestry

  belongs_to :user
  belongs_to :blogpost
  belongs_to :podcast

  # --- Permissions --- #

  def create_permitted?
    acting_user.state == "active"
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

  #--- Instance Methods ---#

  def text_begin
    "#{user.email_address}: #{content.truncate(100)}"
  end
end