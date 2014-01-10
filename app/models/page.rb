class Page < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de   :string, :required, :name => true
    title_en   :string
    url        :string
    ancestry   :string, :index => true
    position   :integer, :required
    legacy_id  :integer
    timestamps
  end
  attr_accessible :title_de, :title_en, :page_content_element_assignments, :content_elements,
                  :position, :parent_id, :parent, :position, :page_template, :url
  translates :title
  has_ancestry

  has_paper_trail
  never_show :ancestry
  default_scope { order('pages.position ASC') }

  validates :position, numericality: true

  has_many :page_content_element_assignments, :accessible => true
  has_many :content_elements, :through => :page_content_element_assignments

  belongs_to :page_template
  validates :page_template, :presence => true

  alias_attribute :name, :title_de

  lifecycle do
    state :draft, :default => true
    state :published, :published_but_hidden, :archived

    transition :publish, { [:draft, :archived] => :published }, :available_to => "User.administrator"
    transition :archive, { [:published, :published_but_hidden] => :archived }, :available_to => "User.administrator"
    transition :hide, { :published => :published_but_hidden }, :available_to => "User.administrator"
    transition :unhide, { :published_but_hidden => :published }, :available_to => "User.administrator"
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
