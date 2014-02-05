class Property < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de        :string, :required, :unique
    name_en        :string
    datatype       enum_string(:textual, :numeric, :flag), :required

    position       :integer, :required
    legacy_id      :integer
    timestamps
  end

  default_scope { order(position: :asc) }
  attr_accessible :name_de, :name_en, :description_de, :description_en, :value, :unit_de, :unit_en,
                  :position, :legacy_id
  has_paper_trail
  translates :name, :description, :unit

  validates :position, numericality: true
  validates :datatype,inclusion: { in: %w(textual numeric flag) }

  has_many :property_groups, :through => :values
  has_many :products, :through => :values
  has_many :values, dependent: :destroy, :inverse_of => :property, :accessible => true

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