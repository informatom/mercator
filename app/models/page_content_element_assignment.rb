class PageContentElementAssignment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    used_as    :string
    timestamps
  end
  attr_accessible :used_as, :page, :content_element, :page_id, :content_element_id

  validates :used_as, :presence => true, :uniqueness => {:scope => :page_id}

  has_paper_trail

  belongs_to :page
  validates :page, :presence => true

  belongs_to :content_element
  validates :content_element, :presence => true

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