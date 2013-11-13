class PropertyGroup < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de  :string, :required
    name_en  :string
    position :integer, :required
    timestamps
  end
  attr_accessible :name_de, :name_en, :position, :product, :product_id

  translates :name
  has_paper_trail

  belongs_to :product
  validates :product_id, :presence => true
  has_many :properties
  children :properties

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