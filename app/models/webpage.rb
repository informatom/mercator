class Webpage < ActiveRecord::Base
  hobo_model # Don't put anything above this

  fields do
    title_de   :string, :required, :name => true
    title_en   :string
    url        :string, :required, :index => true
    ancestry   :string, :index => true
    position   :integer, :required
    legacy_id  :integer
    slug       :string, :unique
    timestamps
  end

  attr_accessible :title_de, :title_en, :page_content_element_assignments, :content_elements,
                  :position, :parent_id, :parent, :position, :page_template, :url
  translates :title
  has_ancestry

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  def slug_candidates
    [:url, :title_de]
  end

  has_paper_trail
  never_show :ancestry
  default_scope { order('webpages.position ASC') }

  validates :position, numericality: true

  has_many :page_content_element_assignments, :accessible => true
  has_many :content_elements, :through => :page_content_element_assignments

  children :content_elements

  belongs_to :page_template
  validates :page_template, :presence => true

  alias_attribute :name, :title_de

  lifecycle do
    state :draft, :default => true
    state :published, :published_but_hidden, :archived

    transition :publish, { [:draft, :archived] => :published },
               :available_to => "User.administrator", :subsite => "admin"
    transition :archive, { [:published, :published_but_hidden] => :archived },
               :available_to => "User.administrator", :subsite => "admin"
    transition :hide, { :published => :published_but_hidden },
               :available_to => "User.administrator", :subsite => "admin"
    transition :unhide, { :published_but_hidden => :published },
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

  # --- Instance Methods --- #

  def element_name(used_as)
    PageContentElementAssignment.where(webpage_id: self.id, used_as: used_as).first.try(:content_element).try(:name).html_safe
  end

  def element_content(used_as)
    PageContentElementAssignment.where(webpage_id: self.id, used_as: used_as).first.try(:content_element).try(:content).html_safe
  end
end