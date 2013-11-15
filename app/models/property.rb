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
  has_paper_trail
  translates :name, :description, :unit

  belongs_to :product
  belongs_to :property_group

  validate :textual_or_numerical

  validates :name_de, :presence => true, :uniqueness => {:scope => :product_id}
  validates :product, :presence => true

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