class Property < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de        :string, :required
    name_en        :string
    description_de :string
    description_en :string
    value          :decimal, :precision => 10, :scale => 2
    unit_de        :string
    unit_en        :string
    datatype       enum_string(:textual, :numeric, :flag)

    position       :integer, :required
    legacy_id      :integer
    timestamps
  end

  attr_accessible :name_de, :name_en, :description_de, :description_en, :value, :unit_de, :unit_en,
                  :position, :legacy_id
  has_paper_trail
  translates :name, :description, :unit

  validates :value, numericality: true, allow_nil: true
  validates :position, numericality: true

  has_many :property_groups, :through => :values
  has_many :products, :through => :values
  has_many :values, dependent: :destroy, :inverse_of => :property, :accessible => true

  # validate :textual_or_numerical

  def textual_or_numerical
    unless (self.value.present? && self.unit_de.present? && self.description_de.blank?) ||
           (self.value.blank? && self.unit_de.blank? && self.description_de.present?)
      errors.add(:base, I18n.translate("errors.messages.textual_or_numerical"))
    end
  end

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