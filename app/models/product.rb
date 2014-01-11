class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de        :string, :required
    name_en        :string
    number         :string, :required, :unique
    description_de :cktext, :required
    description_en :cktext
    legacy_id      :integer
    timestamps
  end
  attr_accessible :name_de, :name_en, :number, :description_de, :description_en,
                  :photo, :document, :productrelations, :supplyrelations,
                  :inventories, :recommendations, :legacy_id, :categories, :categorizations
  translates :name, :description
  has_paper_trail

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  has_many :property_groups, dependent: :destroy, :accessible => true, :inverse_of => :product
  has_many :properties, dependent: :destroy, :through => :property_groups

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

  def self.find_by_name(param)
    self.find_by_name_de(param)
  end

  lifecycle do
    state :new, :default => true
    state :announced, :active, :deprecated
    transition :activate, {:new => :active}, :available_to => "User.administrator"
    transition :announce, {:new => :announced}, :available_to => "User.administrator"
    transition :release, {:announced => :active}, :available_to => "User.administrator"
    transition :deactivate, { :active => :deprecated }, :available_to => "User.administrator"
    transition :reactivate, { :deprecated => :active }, :available_to => "User.administrator"
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
end