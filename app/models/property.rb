class Property < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de        :string, :required
    name_en        :string
    datatype       enum_string(:textual, :numeric, :flag), :required

    position       :integer, :required
    legacy_id      :integer
    icecat_id      :integer, :unique, :index => true
    timestamps
  end

  default_scope { order(position: :asc) }
  attr_accessible :name_de, :name_en, :description_de, :description_en, :value, :unit_de, :unit_en,
                  :position, :legacy_id, :datatype, :icecat_id
  has_paper_trail
  translates :name, :description, :unit
  acts_as_list

  validates :position, numericality: true
  validates :datatype,inclusion: { in: %w(textual numeric flag) }

  has_many :property_groups, :through => :values
  has_many :products, :through => :values
  has_many :values, dependent: :destroy, :inverse_of => :property, :accessible => true

  lifecycle do
    state :filterable, :default => true
    state :unfilterable

    transition :dont_filter,
               {:filterable => :unfilterable},
               :available_to => "User.administrator",
               :subsite => "admin"
    transition :filter, {:unfilterable => :filterable}, :available_to => "User.administrator", :subsite => "admin"
  end

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
    orphaned_values = Value.where.not(property_id: Property.pluck(:id)).count
    orphaned_values == 0 or JobLogger.error("There are " + orphaned_values + " orphaned values.")

    Property.all.group_by(&:name_de).each do |name, properties|
       we_keep_id = properties.first.id
       properties.shift
       properties.each do |property|
         values_to_move = Value.where(property_id: property.id)
         values_to_move.update_all(property_id: we_keep_id) or JobLogger.error("Could not update values!")
         property.destroy or JobLogger.error("Could not delete Property " + property.id.to_s + "!")
       end
    end

    Property.all.each do |property|
      if property.values.count == 0
        property.destroy or JobLogger.error("Could not delete Property " + property.id.to_s + "!")
      end
    end
  end
end