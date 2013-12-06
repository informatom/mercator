class Category < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de  :string, :required
    name_en  :string, :tequired
    description_de :text
    description_en :text
    long_description_de :text
    long_description_en :text
    ancestry :string, :index => true
    position :integer
    legacy_id      :integer
    timestamps
  end

  attr_accessible :name_de, :name_en, :ancestry, :position, :active,
                  :parent_id, :parent, :categorizations, :products
  translates :name, :description, :long_description
  has_ancestry
  has_paper_trail
  never_show :ancestry

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :large => "1000x1000>", :medium => "500x500>", :small => "250x250>",
                 :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates :position, numericality: true

  has_many :categorizations, dependent: :destroy, :order => :position
  has_many :products, :through => :categorizations, :accessible => true, :inverse_of => :categories

  lifecycle do
    state :new, :default => true
    state :active, :deprecated

    transition :activate, {:new => :active}, :available_to => "User.administrator"
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
