class PropertyGroup < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de   :string, :required
    name_en   :string
    position  :integer, :required
    icecat_id :integer, :unique, :index => true
    timestamps
  end

  acts_as_list

  attr_accessible :name_de, :name_en, :position, :icecat_id
  translates :name
  has_paper_trail
  default_scope { order('property_groups.position ASC') }

  validates :position, numericality: { only_integer: true }

  has_many :products, :through => :values
  has_many :properties, -> { uniq }, :through => :values
  has_many :values, dependent: :destroy, :inverse_of => :property_group, :accessible => true

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