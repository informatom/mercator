class PropertyGroup < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de  :string #, required
    name_en  :string
    position :integer, :required
    timestamps
  end

  attr_accessible :name_de, :name_en, :position, :product, :product_id,
                  :properties
  translates :name
  has_paper_trail
  acts_as_list :scope => :product

  validates :position, numericality: true

  belongs_to :product
  validates :product, :presence => true
  has_many :properties, :accessible => true

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