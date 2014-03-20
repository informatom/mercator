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
  never_show :ancestry
  default_scope { order('categories.position ASC') }

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

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
end