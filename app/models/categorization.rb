class Categorization < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position :integer, :required
    timestamps
  end

  attr_accessible :product, :product_id, :category, :category_id
  has_paper_trail
  default_scope order('categorizations.position ASC')

  belongs_to :category
  belongs_to :product
  acts_as_list :scope => :category

  validates :product, :presence => true
  validates :category_id, :presence => true, :uniqueness => {:scope => :product_id}

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
