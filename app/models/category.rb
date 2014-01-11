class Category < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de             :string, :required
    name_en             :string, :tequired
    description_de      :text
    description_en      :text
    long_description_de :text
    long_description_en :text
    ancestry            :string, :index => true
    position            :integer, :required
    legacy_id           :integer
    timestamps
  end

  attr_accessible :name_de, :name_en, :ancestry, :position, :active,
                  :parent_id, :parent, :categorizations, :products, :document, :photo
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

  has_many :categorizations, -> { order :position }, dependent: :destroy
  has_many :products, :through => :categorizations, :accessible => true, :inverse_of => :categories

  def self.find_by_name(param)
    self.find_by_name_de(param)
  end

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

  def ancestors
    self.ancestor_ids.map { |id| Category.find(id) }
  end

  def active_siblings
    Category.siblings_of(self).active - [self]
  end

  def active_children
    Category.children_of(self).active
  end


end
