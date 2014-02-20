class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de       :string, :required
    title_en       :string
    number         :string, :required, :unique, name: true
    description_de :cktext, :required
    description_en :cktext
    legacy_id      :integer
    timestamps
  end
  attr_accessible :title_de, :title_en, :number, :description_de, :description_en,
                  :photo, :document, :productrelations, :supplyrelations,
                  :inventories, :recommendations, :legacy_id, :categories, :categorizations
  set_search_columns :title_de, :title_en, :description_de, :description_en, :number
  translates :title, :description
  has_paper_trail

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  has_many :property_groups, :through => :values
  has_many :properties, :through => :values
  has_many :values, dependent: :destroy, :inverse_of => :product, :accessible => true

  has_many :categories, :through => :categorizations
  has_many :categorizations, dependent: :destroy, :inverse_of => :product, :accessible => true

  has_many :related_products, :through => :productrelations
  has_many :productrelations, :inverse_of => :product, dependent: :destroy, :accessible => true

  has_many :recommended_products, :through => :recommendations
  has_many :recommendations, :inverse_of => :product, dependent: :destroy, :accessible => true

  has_many :supplies, :through => :supplyrelations
  has_many :supplyrelations, :inverse_of => :product, dependent: :destroy, :accessible => true

  has_many :inventories, dependent: :restrict_with_exception, :inverse_of => :product

  has_many :features, :inverse_of => :product

  children :inventories, :properties, :categories, :related_products, :supplies,
           :recommended_products, :features


  lifecycle do
    state :new, :default => true
    state :announced, :active, :deprecated

    transition :add_to_basket, {:active => :active}, :available_to => :all do
      acting_user.basket.add_product(product: self)
    end

    transition :compare, {:active => :active}, :available_to => :all
    transition :dont_compare, {:active => :active}, :available_to => :all

    transition :activate, {:new => :active}, :available_to => "User.administrator", :subsite => "admin"
    transition :deactivate, { :active => :deprecated }, :available_to => "User.administrator", :subsite => "admin"
    transition :reactivate, { :deprecated => :active }, :available_to => "User.administrator", :subsite => "admin"
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

  def price (amount: 1, date: Time.now())
    inventory = self.inventories.first
    price = inventory.prices.where{(valid_to >= date) & (valid_from <= date) &
                                   (scale_from <= amount) & (scale_to >= amount)}.first.value
    return price
  end

  def price_incl_vat(amount: 1, date: Time.now())
    inventory = self.inventories.first
    vat = inventory.prices.where{(valid_to >= date) & (valid_from <= date) &
                                 (scale_from <= amount) & (scale_to >= amount)}.first.vat
    self.price(amount: amount, date: date) * (100 + vat) / 100
  end

  def delivery_time
    inventory = self.inventories.first
    inventory.delivery_time
  end

  def tabled_values
    nested_hash = ActiveSupport::OrderedHash.new
    values = Value.where(product_id: id).sort_by { |a| [a.property_group.position, a.property.position]}
    values.each do |value|
      property_name = value.property.name || value.property.name_en
      nested_hash[value.property_group.name] ||= ActiveSupport::OrderedHash.new
      nested_hash[value.property_group.name][property_name] = value.display
    end
    return nested_hash
  end

  #--- Class Methods --- #

  def self.find_by_name(param)
    self.find_by_number(param)
  end
end