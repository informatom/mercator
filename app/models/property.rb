class Property < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de  :string
    name_en  :string
    description_de :string
    description_en :string
    value :decimal
    unit_de :string
    unit_en :string

    position :integer
    timestamps
  end
  attr_accessible :name_de, :name_en, :description_de, :description_en, :value, :unit_de, :unit_en,
                  :position, :product, :property_group, :product_id, :property_group_id

  translates :name, :description, :unit
  belongs_to :product
  belongs_to :property_group

  has_paper_trail

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
