class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de            :string, :required
    title_en            :string
    number              :string, :required, :unique, name: true
    description_de      :text, :required
    description_en      :text
    long_description_de :cktext
    long_description_en :cktext
    warranty_de         :cktext
    warranty_en         :cktext
    legacy_id           :integer
    novelty             :boolean
    topseller           :boolean
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_icecat/app/models/product_extensions.rb
  include ProductExtensions if Rails.application.config.try(:icecat) == true

  attr_accessible :title_de, :title_en, :number, :description_de, :description_en,
                  :long_description_de, :long_description_en,
                  :photo, :document, :productrelations, :supplyrelations,
                  :inventories, :recommendations, :legacy_id, :categories, :categorizations,
                  :novelty, :topseller

  translates :title, :description, :long_description, :warranty
  has_paper_trail

  def self.active_and_number_contains(number)
    Product.active.number_contains(number)
  end

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

  has_many :inventories, dependent: :restrict_with_exception, :inverse_of => :product
  has_many :prices, :through => :inventories

  has_many :features, :inverse_of => :product

  lifecycle do
    state :new, :default => true
    state :announced, :active, :deprecated

    transition :add_to_basket, {:active => :active}, :available_to => :all do
      acting_user.basket.add_product(product: self)
    end

    transition :compare, {:active => :active}, :available_to => :all
    transition :dont_compare, {:active => :active}, :available_to => :all

    transition :activate, {:new => :active}, :available_to => "User.administrator", :subsite => "admin"
    transition :deactivate, { :new => :deprecated }, :available_to => "User.administrator", :subsite => "admin"
    transition :deactivate, { :active => :deprecated }, :available_to => "User.administrator", :subsite => "admin"
    transition :reactivate, { :deprecated => :active }, :available_to => "User.administrator", :subsite => "admin"
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
    if Constant.find_by_key("fifo").value == "true"
      inventories.order(created_at: :asc).where{(amount >= my{amount_requested}) | (infinite == true)}.first # FIFO
    else
      inventories.order(created_at: :desc).where{(amount >= my{amount_requested}) | (infinite == true)}.first # LIFO
    end
  end

  # --- Searchkick Instance Methods --- #

  def search_data
    @price_user = User.find_by(surname: "Dummy Customer")
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
      price:            determine_price(customer_id: @price_user.id) }.merge(property_hash)
  end

  def property_hash
    JobLogger.info("Product " + id.to_s + " reindexed.")
    Hash[values.select { |value| value.property.state == "filterable"}
               .map { |value| [value.property.name_de, value.display.rstrip] }]
  end

  #--- Class Methods --- #

  def self.find_by_name(param)
    find_by_number(param)
  end

  def self.create_in_auto(number: nil, title: nil, description: nil)
    @auto_category = Category.auto

    if @auto_category.categorizations.any?
      newposition = @auto_category.categorizations.maximum(:position) +1
    else
      newposition = 1
    end

    description = title if description.blank?
    @product = new(number:         number,
                   title_de:       title,
                   description_de: description)
    @product.categorizations.new(category_id: @auto_category.id,
                                 position:    newposition)
    if @product.save
      ::JobLogger.info("Product " + @product.number + " saved in Auto Category.")
    else
      ::JobLogger.error("Product " + @product.number + " could not be saved in Auto Category!")
    end
    return @product
  end

  def self.deprecate
    @jobuser = User.find_by(surname: "Job User")

    Product.where(state: ["active", "new"]).each do |product|
      unless product.inventories.any?
        product.lifecycle.deactivate!(@jobuser) or JobLogger.error("Product " + product.number + " could not be deactivated!")
      end
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
        product.save or JobLogger.error("Product " + product.number + " could not be added to orphans. (" + index.to_s + "/" + amount.to_s + ")")
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

  def self.show_diffs_of_double_priced_in_stdout
    with_at_least_two_prices.each do |product|
      puts product.number, product.prices[0].attributes.to_a - product.prices[1].attributes.to_a
    end
  end
end