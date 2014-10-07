class Value < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de :string
    title_en :string
    amount   :decimal, :precision => 10, :scale => 2
    unit_de  :string
    unit_en  :string
    flag     :boolean
    timestamps
  end
  attr_accessible :title_de, :title_en, :amount, :flag, :product, :property_group, :property
  translates :title, :unit
  has_paper_trail

  belongs_to :property_group
  validates :property_group, :presence => true

  belongs_to :property
  validates :property, :presence => true

  belongs_to :product
  validates :product, :presence => true

  validates :amount, numericality: true, allow_nil: true

  validate :data_meets_state

  def data_meets_state
    case state
      when "textual"
        unless title_de.present? && amount.blank? && flag.nil?
          errors.add(:base, I18n.translate("errors.messages.data_meets_state"))
        end
      when "numeric"
        unless amount.present? && title_de.blank? && title_en.blank? && flag.nil?
          errors.add(:base, I18n.translate("errors.messages.data_meets_state"))
        end
      when "flag"
        unless !flag.nil? && title_de.blank? && title_en.blank? && amount.blank? && unit_de.blank? && unit_en.blank?
          errors.add(:base, I18n.translate("errors.messages.data_meets_state"))
        end
    end
  end

  lifecycle do
    state :textual, default: true
    state :numeric, :flag
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

  # --- Instance Methods --- #

  def display
    case state
    when "textual"
      title + " " + unit.to_s
    when "numeric"
      if amount.to_i == amount
        amount.to_i.to_s + " " + unit.to_s
      else
        amount.to_s + " " + unit.to_s
      end
    when "flag"
      flag == true ? "ja" : "nein"
    end
  end

end