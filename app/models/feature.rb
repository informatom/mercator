class Feature < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position :integer, :required
    text_de  :string, :required
    text_en  :string
    timestamps
  end
  attr_accessible :position, :text_de, :text_en
  has_paper_trail
  default_scope { order('features.position ASC') }

  translates :text
  validates :position, numericality: true, :uniqueness => {:scope => :product_id}

  belongs_to :product
  validates :product, :presence => true  

  acts_as_list :scope => :product

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
