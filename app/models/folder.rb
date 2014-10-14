class Folder < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name     :string
    ancestry :string, :index => true
    position :integer, :required
    timestamps
  end

  attr_accessible :name, :ancestry, :position
  has_ancestry orphan_strategy: :adopt

  has_paper_trail
  never_show :ancestry
  default_scope { order('folders.position ASC') }

  validates :position, numericality: true
  has_many :content_elements

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
