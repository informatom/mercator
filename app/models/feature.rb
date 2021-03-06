class Feature < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position :integer, :required
    text_de  :string, :required
    text_en  :string
    legacy_id :integer
    timestamps
  end
  attr_accessible :position, :text_de, :text_en, :legacy_id, :product, :product_id
  has_paper_trail
  default_scope { order('features.position ASC') }

  translates :text
  validates :position, numericality: { only_integer: true }

  belongs_to :product
  validates :product, :presence => true

  acts_as_list :scope => :product

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator? ||
    acting_user.productmanager?
  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.productmanager?
  end

  def destroy_permitted?
    acting_user.administrator? ||
    acting_user.productmanager?
  end

  def view_permitted?(field)
    true
  end
end