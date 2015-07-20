class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de            :string, :required
    title_en            :string
    number              :string, :required, :unique, name: true
    alternative_number  :string
    description_de      :text
    description_en      :text
    long_description_de :cktext
    long_description_en :cktext
    warranty_de         :cktext
    warranty_en         :cktext
    legacy_id           :integer
    not_shippable       :boolean
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_icecat/app/models/product_extensions.rb
  include ProductExtensions if Rails.application.config.try(:icecat) == true

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/mercator_product_extensions.rb
  include MercatorProductExtensions if Rails.application.config.try(:erp) == "mesonic"

  attr_accessible :title_de, :title_en, :number, :description_de, :description_en,
                  :long_description_de, :long_description_en,
                  :photo, :document, :productrelations, :supplyrelations,
                  :inventories, :recommendations, :legacy_id, :categories, :categorizations,
                  :warranty_de, :warranty_en, :not_shippable, :alternative_number

  translates :title, :description, :long_description, :warranty
  has_paper_trail


  searchkick language: "German"

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  do_not_validate_attachment_file_type :document
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_many :property_groups, :through => :values
  has_many :properties, :through => :values
  has_many :values, dependent: :destroy, :inverse_of => :product, :accessible => true

  has_many :categories, :through => :categorizations, inverse_of: :products
  has_many :categorizations, dependent: :destroy, :inverse_of => :product, :accessible => true

  has_many :related_products, :through => :productrelations
  has_many :productrelations, :inverse_of => :product, dependent: :destroy, :accessible => true

  has_many :recommended_products, :through => :recommendations
  has_many :recommendations, :inverse_of => :product, dependent: :destroy, :accessible => true

  has_many :supplies, :through => :supplyrelations
  has_many :supplyrelations, :inverse_of => :product, dependent: :destroy, :accessible => true

  has_many :inventories, dependent: :restrict_with_error, :inverse_of => :product
  has_many :prices, :through => :inventories

  has_many :features, :inverse_of => :product


  # --- Lifecycle --- #

  lifecycle do
    state :new, :default => true
    state :announced, :active, :deprecated

    transition :add_to_basket, {:active => :active}, :available_to => :all
    transition :compare, {:active => :active}, :available_to => :all
    transition :dont_compare, {:active => :active}, :available_to => :all

    transition :activate, {:new => :active}, :subsite => "admin",
               :available_to => "acting_user if (acting_user.administrator? || acting_user.productmanager?)"
    transition :deactivate, { :new => :deprecated }, :subsite => "admin",
    :available_to => "acting_user if (acting_user.administrator? || acting_user.productmanager?)"
    transition :deactivate, { :active => :deprecated }, :subsite => "admin",
    :available_to => "acting_user if (acting_user.administrator? || acting_user.productmanager?)"
    transition :reactivate, { :deprecated => :active }, :subsite => "admin",
    :available_to => "acting_user if (acting_user.administrator? || acting_user.productmanager?)"

    transition :add_to_offer, {:active => :active}, :available_to => "User.sales", :subsite => "sales"
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


  # --- Instance Methods --- #

  def determine_price(amount: 1, date: Time.now(), incl_vat: false, customer_id: nil)
    customer_id ||= current_user.id if try(:current_user)

    inventory = determine_inventory(amount: amount)
    if inventory
      return inventory.determine_price(amount:      amount,
                                       date:        date,
                                       incl_vat:    incl_vat,
                                       customer_id: customer_id)
    else
      return nil
    end
  end


  def delivery_time(amount: 1, date: Time.now())
    inventory = determine_inventory(amount: amount)
    delivery_time = inventory ? inventory.delivery_time : I18n.t("mercator.on_request")
    return delivery_time
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


  def hashed_values
    nested_hash = ActiveSupport::OrderedHash.new
    values = Value.includes(:property_group) #eager loading relation ...
                  .includes(:property)
                  .where(product_id: id).sort_by { |a| [a.property_group.position, a.property.position]}
    hashed_values = values.group_by(&:property_group_id)
    return hashed_values
  end


  def determine_inventory(amount: 1)
    amount_requested = amount
    if Constant.find_by_key("fifo").try(:value) == "true"
      inventories.order(created_at: :asc).where{(amount >= my{amount_requested}) | (infinite == true)}.first # FIFO
    else
      inventories.order(created_at: :desc).where{(amount >= my{amount_requested}) | (infinite == true)}.first # LIFO
    end
  end


  # --- Searchkick Instance Methods --- #

  def search_data
    @price_user = User.find_by(surname: "Dummy Customer")
    @price =
    if Constant.find_by_key('display_only_brutto_prices').try(:value) == 'true'
      determine_price(customer_id: @price_user.id, incl_vat: true)
    else
      determine_price(customer_id: @price_user.id, incl_vat: false)
    end

    { title:            title_de,
      title_de:         title_de,
      title_en:         title_en,
      number:           number,
      description:      description_de,
      description_de:   description_de,
      description_en:   description_en,
      long_description: long_description_de,
      warranty:         warranty_de,
      category_ids:     categories.pluck(:id),
      state:            state,
      price:            @price }.merge(property_hash)
  end


  def property_hash
    Hash[values.select { |value| value.property.state == "filterable"}
               .map { |value| [value.property.name, value.display.rstrip] }]
  end


  #--- Class Methods --- #

  def self.find_by_name(param)
    find_by_number(param)
  end


  def self.deprecate
    Product.where(state: ["active", "new"]).each do |product|
      product.lifecycle.deactivate!(User::JOBUSER) unless product.inventories.any?
    end
  end


  def self.catch_orphans
    @orphans = Category.orphans
    position = 1
    amount = Product.count
    Product.all.each_with_index do |product, index|
      unless product.categorizations.any?
        position = @orphans.categorizations.maximum(:position) + 1 if @orphans.categorizations.any?
        product.categorizations.new(category_id: @orphans.id, position: position)
        product.save or
        ((JobLogger.error("Product " + product.number +
                          " could not be added to orphans. (" + index.to_s +
                          "/" + amount.to_s + ")")))
      end
    end
  end


  def self.with_at_least_x_prices(x)
    products = []
    Product.all.each do |product|
      products << product if product.prices.count >= x
    end
    return products
  end

  def self.with_at_most_x_prices(x)
    products = []
    Product.all.each do |product|
      products << product if product.prices.count <= x
    end
    return products
  end


  def self.diffs_of_double_priced
    with_at_least_x_prices(2).each do |product|
      ap product.number
      ap product.prices[0]
      ap product.prices[1]
    end
  end


  def self.activate_all
    Product.all.each do |product|
      if product.lifecycle.available_transitions.*.name.include?(:activate)
        product.lifecycle.activate!(User::JOBUSER)
      end
    end
  end


  def self.active_and_number_contains(number)
    Product.active.number_contains(number)
  end
end