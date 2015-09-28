class Price < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    value          :decimal, :required, :precision => 13, :scale => 5
    vat            :decimal, :required, :precision => 10, :scale => 2
    valid_from     :date, :required
    valid_to       :date, :required
    scale_from     :decimal, :required, :precision => 10, :scale => 2
    scale_to       :decimal, :required, :precision => 10, :scale => 2
    promotion      :boolean
    erp_identifier :integer
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/price_extensions.rb
  include PriceExtensions if Rails.application.config.try(:erp) == "mesonic"

  attr_accessible :vat, :value, :valid_from, :valid_to, :scale_from,
                  :scale_to, :inventory, :inventory_id, :promotion, :erp_identifier
  has_paper_trail

  validates :value, numericality: true, allow_nil: true
  validates :vat, numericality: true, allow_nil: true
  validates :scale_from, numericality: true, allow_nil: true
  validates :scale_to, numericality: true, allow_nil: true

  validates :erp_identifier, uniqueness: true, unless: :product_validations

  belongs_to :inventory
  validates :inventory, :presence => true

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


  # --- Instance methods --- #

  def product_validations
    Constant.find_by_key('erp_product_variations').try(:value) == true
  end
end