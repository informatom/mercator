class Blogpost < ActiveRecord::Base
  hobo_model # Don't put anything above this

  fields do
    title_de        :string
    title_en        :string
    publishing_date :date
    timestamps
  end
  attr_accessible :title_de, :title_en, :publishing_date

  translates :title
  has_paper_trail
  belongs_to :content_element

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?    acting_user.administrator? ||
    acting_user.contentmanager?  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.contentmanager?
  end

  def destroy_permitted?
    acting_user.administrator? ||
    acting_user.contentmanager?
  end

  def view_permitted?(field)
    true
  end
end