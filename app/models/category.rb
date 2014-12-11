class Category < ActiveRecord::Base
  hobo_model # Don't put anything above this

  fields do
    name_de             :string, :required
    name_en             :string, :required
    description_de      :cktext
    description_en      :cktext
    long_description_de :cktext
    long_description_en :cktext
    ancestry            :string, :index => true
    position            :integer, :required
    legacy_id           :integer
    filters             :serialized
    filtermin           :decimal, :required, :precision => 10, :scale => 2
    filtermax           :decimal, :required, :precision => 10, :scale => 2
    timestamps
  end

  attr_accessible :name_de, :name_en, :state, :ancestry, :position, :active,
                  :parent_id, :parent, :categorizations, :products, :document, :photo,
                  :description_de, :description_en, :long_description_de, :long_description_en, :filters

  translates :name, :description, :long_description

  has_ancestry orphan_strategy: :adopt
  has_paper_trail

  searchkick language: "German"

  never_show :ancestry, :filters
  default_scope { order('categories.position ASC') }

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  do_not_validate_attachment_file_type :document
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  validates :position, numericality: { only_integer: true }

  has_many :products, :through => :categorizations, :inverse_of => :categories
  has_many :categorizations, -> { order :position }, :inverse_of => :category,
            dependent: :destroy, :accessible => true

  has_many :values, :through => :products
  has_many :properties, :through => :products

  lifecycle do
    state :new, :default => true
    state :active, :deprecated

    transition :activate,
               {:new => :active},
               :available_to => "User.administrator",
               :subsite => "admin"

    transition :deactivate,
               { :active => :deprecated },
               :available_to => "User.administrator",
               :subsite => "admin"

    transition :deactivate,
               { :new => :deprecated },
               :available_to => "User.administrator",
               :subsite => "admin"

    transition :reactivate,
               { :deprecated => :active },
               :available_to => "User.administrator",
               :subsite => "admin"
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

  #--- Instance Methods ---#

  def active_product_count
    products.active.count + descendants.active.joins{ products }.where{ products.state == "active" }.count
  end

  def ancestors
    ancestor_ids.map { |id| Category.find(id) }
  end

  def ancestor_string
    ancestor_names = ancestors.each { |ancestor| ancestor.name}
    ancestor_names.join " - "
  end

  def active_siblings
    Category.siblings_of(self).active - [self]
  end

  def active_children
    Category.children_of(self).active
  end

  def try_deprecation
    return if state != "active" && state != "new"
    return if products.where(state: "active").count > 0

    @any_child_active = false
    children.each do |child|
      child.try_deprecation
      @any_child_active = true if child.state == "active"
    end
    return if @any_child_active == true

    lifecycle.deactivate!(User.where(administrator: true).first)
    JobLogger.info("Category " + name_de + " deactivated.")
  end

  def property_groups_hash
    product_ids = products.includes(:values).active.*.id
    values = Value.where(product_id: product_ids)
                  .includes(:property_group)
                  .includes(:property)
                  .select{ |value| value.property.state == "filterable"}

    property_pairs = values.map {|value| [value.property_group.name_de, value.property.name_de] }
                           .uniq
    property_groups = property_pairs.group_by { |pair| pair[0]}
    property_groups.each {|key,value| property_groups[key] = value.map{|pair| pair[1]} }
    return property_groups
  end

  def update_property_hash
    update( filters: property_groups_hash)
  end

  def starting_from
    filtermins = (descendants.active.*.filtermin << filtermin).uniq
    filtermins.delete(0.0)
    return filtermins.min
  end

  def up_to
    filtermaxs = (descendants.active.*.filtermax << filtermax).uniq
    filtermaxs.delete(1000.0)
    return filtermaxs.max
  end

  def name_with_status
    if state == "active"
      name
    else
      (name + " <em style='color: green'>" + I18n.t("mercator.states.#{state}") + "</em>").html_safe
    end
  end


  # --- Searchkick Instance Methods --- #

  def search_data
    {
      name: name_de,
      name_de: name_de,
      name_en: name_en,
      description: description_de,
      description_de: description_de,
      description_en: description_en,
      long_description: long_description_de,
      long_description_de: long_description_de,
      long_description_en: long_description_en,
      state: state
    }
  end

  #--- Class Methods --- #

  def self.find_by_name(param)
    find_by_name_de(param)
  end

  def self.auto
    @auto = Category.where(name_de: "automatisch").first
    @auto = create(
      name_de: "automatisch",
      name_en: "automatic",
      description_de: "Automatisch angelegte Produkte aus ERP Batchimport",
      description_en: "automatically created froducts from ERP import Job",
      long_description_de: "Bitte Produkte vervollständigen und kategorisieren.",
      long_description_en: "Please complete products and put them into categories",
      parent: nil,
      position: 1,
      filtermin: 1,
      filtermax: 1 ) unless @auto
    return @auto
  end

  def self.discounts
    @discounts = Category.where(name_de: "Aktionen").first
    @discounts = create(
      name_de: "Aktionen",
      name_en: "Discounts",
      description_de: "Aktionsartikel",
      description_en: "Dicounted Articles",
      long_description_de: "Aktionsartikel",
      long_description_en: "Dicounted Articles",
      parent: nil,
      position: 1,
      filtermin: 1,
      filtermax: 1) unless @discounts
    return @discounts
  end

  def self.novelties
    @novelties = Category.where(name_de: "Neuheiten").first
    @novelties = create(
      name_de: "Neuheiten",
      name_en: "New",
      description_de: "Neuheiten",
      description_en: "New",
      long_description_de: "Neuheiten",
      long_description_en: "Novelties",
      parent: nil,
      position: 1,
      filtermin: 1,
      filtermax: 1) unless @novelties
    return @novelties
  end

  def self.topseller
    @topseller = Category.where(name_de: "Topseller").first
    @topseller = create(
      name_de: "Topseller",
      name_en: "Topseller",
      description_de: "Topseller",
      description_en: "Topseller",
      long_description_de: "Topseller",
      long_description_en: "Topseller",
      parent: nil,
      position: 1,
      filtermin: 1,
      filtermax: 1) unless @topseller
    return @topseller
  end

  def self.orphans
    @orphans = Category.where(name_de: "verwaiste Produkte").first
    @orphans = create(
      name_de: "verwaiste Produkte",
      name_en: "Orphans",
      description_de: "verwaiste Produkte",
      description_en: "Orphans",
      long_description_de: "verwaiste Produkte",
      long_description_en: "Orphans",
      parent: nil,
      position: 1,
      filtermin: 1,
      filtermax: 1) unless @orphans
    return @orphans
  end

  def self.deprecate
    Category.roots.each do |category|
      category.try_deprecation
    end
  end

  def self.update_property_hash
    Category.order(id: :asc).load.each do |category|
      category.update_property_hash
    end
  end

  def self.reindexing_and_filter_updates
    Category.reindex

    Category.order(:id).each do |category|
      category.reindex
      category.update_property_hash

      # determine_price returns nil, if no price can be found
      category_prices = category.products.*.determine_price(customer_id: @price_user.id).compact

      if category_prices.any?
        category.update(filtermin: category_prices.min.round,
                        filtermax: (category_prices.max + 0.5).round )
      else
        category.update(filtermin: 0,
                        filtermax: 1000)
      end

      JobLogger.info("Reindexed Category: " + category.id.to_s)
    end

  end

  # this makes state editable from form
  Category.attr_protected[:default] = Category.attr_protected[:default].subtract(["state"])
end