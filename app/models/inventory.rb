class Inventory < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de                 :string, :required
    name_en                 :string
    number                  :string,  :required
    amount                  :decimal, :required, :precision => 10, :scale => 2
    unit                    :string,  :required
    comment_de              :string
    comment_en              :string
    weight                  :decimal, :precision => 10, :scale => 2
    charge                  :string
    storage                 :string
    delivery_time           :string
    erp_updated_at          :datetime
    erp_vatline             :integer
    erp_article_group       :integer
    erp_provision_code      :integer
    erp_characteristic_flag :integer
    infinite                :boolean
    just_imported           :boolean
    alternative_number      :string #used for bechlem
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/order_extensions.rb
  include InventoryExtensions if Rails.application.config.try(:erp) == "mesonic"

  attr_accessible :name_de, :name_en, :number, :amount, :unit, :comment_de, :comment_en, :weight, :charge, :storage,
                  :product, :product_id, :photo, :delivery_time, :erp_updated_at, :erp_vatline, :erp_article_group,
                  :erp_provision_code, :erp_characteristic_flag, :infinite, :just_imported, :alternative_number
  translates :name, :comment
  has_paper_trail

  validates :amount, numericality: true
  validates :weight, numericality: true, allow_nil: true

  has_attached_file :photo,
    :styles => { :large => "1000x1000>", :medium => "500x500>", :small => "250x250>",
                 :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  belongs_to :product
  validates :product, :presence => true

  has_many :prices, dependent: :destroy
  children :prices

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

   #--- Instance methods ---#

  def determine_price(date: Time.now, amount: 1, incl_vat: false, customer_id: nil)
    customer_id ||= current_user.id if try(:current_user)

    price = select_price(date: date, amount: amount)
    price_excl_vat = price.value if price

    if Rails.application.config.try(:erp) == "mesonic"
      mesonic_price = mesonic_price(customer_id: customer_id)
      price_excl_vat = mesonic_price if mesonic_price
    end

    if incl_vat
      vat = determine_vat(date: date, amount: amount)
      price_incl_vat = price_excl_vat * (100 + vat) / 100
      return price_incl_vat
    else
      return price_excl_vat
    end
  end

  def select_price(date: Time.now, amount: 1)
    price = prices.where{(valid_to >= date) & (valid_from <= date) &
                         (scale_from <= amount) & (scale_to >= amount)}.first
    return price
  end

  def determine_vat(date: Time.now, amount: 1)
    price = select_price(date: date, amount: amount)
    return price.vat
  end

#--- Class methods ---#

  def self.delete_orphans
    Inventory.each do |inventory|
      unless inventory.prices.any?
        inventory.delete
        JobLogger.info("Inventory " + inventory.number + " deleted.")
      end
    end
  end
end