class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de        :string, :required
    name_en        :string
    number         :string, :required, :unique
    description_de :text, :required
    description_en :text
    timestamps
  end
  attr_accessible :name_de, :name_en, :number, :description_de, :description_en,
                  :photo, :document, :categorizations, :categories, :related_products,
                  :productrelations, :supplies, :supplyrelations, :inventories
  translates :name, :description
  has_paper_trail

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :large => "1000x1000>", :medium => "500x500>", :small => "250x250>",
                 :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  has_many :property_groups
  has_many :properties

  has_many :categorizations
  has_many :categories, :through => :categorizations, :accessible => true

  has_many :related_products, :through => :productrelations, :accessible => true
  has_many :productrelations, :inverse_of => :product

  has_many :supplies, :through => :supplyrelations, :accessible => true
  has_many :supplyrelations, :inverse_of => :product

  has_many :inventories

  children :property_groups, :properties, :categories, :related_products, :supplies,
           :inventories

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