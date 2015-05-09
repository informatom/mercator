class PostCategory < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de  :string
    name_en  :string
    ancestry :string, :index => true
    timestamps
  end
  attr_accessible :name_de, :name_en, :parent_id, :parent
  translates :name
  has_ancestry orphan_strategy: :adopt

  has_paper_trail
  never_show :ancestry

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

  # --- Instance Methods --- #
  def position
    0
  end
end