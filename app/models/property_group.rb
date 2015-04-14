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

#--- Class Methods --- #

  def self.dedup
    orphaned_values = Value.where.not(property_group_id: PropertyGroup.pluck(:id)).count
    orphaned_values == 0 or JobLogger.error("There are " + orphaned_values + " orphaned values.")

    PropertyGroup.all.group_by(&:name_de).each do |name, property_groups|
       we_keep_id = property_groups.first.id
       property_groups.shift
       property_groups.each do |property_group|
         values_to_move = Value.where(property_group_id: property_group.id)
         values_to_move.update_all(property_group_id: we_keep_id) or JobLogger.error("Could not update values!")
         property_group.destroy or JobLogger.error("Could not delete PropertyGroup " + property_group.id.to_s + "!")
       end
    end

    PropertyGroup.all.each do |property_group|
      if property_group.values.count == 0
        property_group.destroy or JobLogger.error("Could not delete PropertyGroup " + property_group.id.to_s + "!")
      end
    end
  end
end