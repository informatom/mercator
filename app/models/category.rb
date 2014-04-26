class Category < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de             :string, :required
    name_en             :string, :tequired
    description_de      :cktext
    description_en      :cktext
    long_description_de :cktext
    long_description_en :cktext
    ancestry            :string, :index => true
    position            :integer, :required
    legacy_id           :integer
    timestamps
  end

  attr_accessible :name_de, :name_en, :ancestry, :position, :active,
                  :parent_id, :parent, :categorizations, :products, :document, :photo,
                  :description_de, :description_en, :long_description_de, :long_description_en
  translates :name, :description, :long_description
  has_ancestry
  has_paper_trail

  searchkick language: "German"

  never_show :ancestry
  default_scope { order('categories.position ASC') }

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  do_not_validate_attachment_file_type :document
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  validates :position, numericality: true

  has_many :products, :through => :categorizations, :inverse_of => :categories
  has_many :categorizations, -> { order :position }, :inverse_of => :category,
            dependent: :destroy, :accessible => true

  lifecycle do
    state :new, :default => true
    state :active, :deprecated

    transition :activate, {:new => :active}, :available_to => "User.administrator", :subsite => "admin"
    transition :deactivate, { :active => :deprecated },
               :available_to => "User.administrator", :subsite => "admin"
    transition :reactivate, { :deprecated => :active },
               :available_to => "User.administrator", :subsite => "admin"
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

  #--- Instance Methods ---#

  def ancestors
    self.ancestor_ids.map { |id| Category.find(id) }
  end

  def active_siblings
    Category.siblings_of(self).active - [self]
  end

  def active_children
    Category.children_of(self).active
  end

  def try_deprecation
    return if self.state != "active"
    return if self.products.where(state: "active").count > 0

    @any_child_active = false
    self.children.each do |child|
      child.try_deprecation
      @any_child_active = true if child.state == "active"
    end
    return if @any_child_active == true

    self.lifecycle.deactivate!(User.where(administrator: true).first)
    puts self.name_de + " deactivated."
  end

  # --- Searchkick Instance Methods --- #

  def search_data
    {
      name: name_de,
      description: description_de,
      long_description: long_description_de,
      property_groups: property_groups_hash
    }
  end

  def property_groups_hash
    values = self.products.active.*.values.flatten
    property_pairs = values.map {|value| [value.property_group.name_de, value.property.name_de] }.uniq
    property_groups = property_pairs.group_by { |pair| pair[0]}
    property_groups.each {|key,value| property_groups[key] = value.map{|pair| pair[1]} }
    JobLogger.info("Category " + self.id.to_s + " reindexed.")
    return property_groups
  end

  #--- Class Methods --- #

  def self.find_by_name(param)
    self.find_by_name_de(param)
  end

  def self.auto
    @auto = Category.where(name_de: "automatisch").first
    @auto = self.create(name_de: "automatisch",
                        name_en: "automatic",
                        description_de: "Automatisch angelegte Produkte aus ERP Batchimport",
                        description_en: "automatically created froducts from ERP import Job",
                        long_description_de: "Bitte Produkte vervollständigen und kategorisieren.",
                        long_description_en: "Please complete products and put them into categories",
                        parent: nil,
                        position: 1) unless @auto
    return @auto
  end

  def self.discounts
    @discounts = Category.where(name_de: "Aktionen").first
    @discounts = self.create(name_de: "Aktionen",
                             name_en: "Discounts",
                             description_de: "Aktionsartikel",
                             description_en: "Dicounted Articles",
                             long_description_de: "Aktionsartikel",
                             long_description_en: "Dicounted Articles",
                             parent: nil,
                             position: 1) unless @discounts
    return @discounts
  end

  def self.novelties
    @novelties = Category.where(name_de: "Neuheiten").first
    @novelties = self.create(name_de: "Neuheiten",
                             name_en: "New",
                             description_de: "Neuheiten",
                             description_en: "New",
                             long_description_de: "Neuheiten",
                             long_description_en: "Novelties",
                             parent: nil,
                             position: 1) unless @novelties
    return @novelties
  end

  def self.topseller
    @topseller = Category.where(name_de: "Topseller").first
    @topseller = self.create(name_de: "Topseller",
                             name_en: "Topseller",
                             description_de: "Topseller",
                             description_en: "Topseller",
                             long_description_de: "Topseller",
                             long_description_en: "Topseller",
                             parent: nil,
                             position: 1) unless @topseller
    return @topseller
  end

  def self.deprecate
    Category.roots.each do |category|
      category.try_deprecation
    end
  end
end