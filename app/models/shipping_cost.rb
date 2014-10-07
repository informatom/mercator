class ShippingCost < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    shipping_method :string, :required
    value           :decimal, :required, :precision => 10, :scale => 2
    vat             :decimal, :required, :precision => 10, :scale => 2
    timestamps
  end
  attr_accessible :country, :shipping_method, :value, :country_id, :vat

  has_paper_trail

  validates :value, numericality: true
  validates :vat, numericality: true

  belongs_to :country

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

  #--- Class Methods --- #

  def self.determine(order: nil, shipping_method: "parcel_service_shipment")
    country = Country.where(name_de: order.shipping_country).first
    country_specific_costs = where(country: country, shipping_method: shipping_method)
    if country_specific_costs.any?
      return country_specific_costs.first
    else
      country_unspecific_costs = where(country_id: nil, shipping_method: shipping_method)
      return country_unspecific_costs.first
    end
  end
end