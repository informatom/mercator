class PropertyGroup < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de   :string, :required
    name_en   :string
    position  :integer, :required
    icecat_id :integer, :unique, :index => true
    timestamps
  end

  default_scope { order(position: :asc) }

  attr_accessible :name_de, :name_en, :position, :icecat_id
  translates :name
  has_paper_trail
  acts_as_list

  validates :position, numericality: true

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