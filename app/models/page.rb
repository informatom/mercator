class Page < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de   :string, :required
    title_en   :string
    url        :string
    ancestry   :string, :index => true
    position   :integer
    legacy_id  :integer
    timestamps
  end
  attr_accessible :title_de, :title_en, :page_content_element_assignments, :content_elements,
                  :position, :parent_id, :parent, :position
  translates :title
  has_ancestry

  has_paper_trail
  never_show :ancestry
  default_scope { order('pages.position ASC') }

  validates :position, numericality: true

  has_many :page_content_element_assignments, :accessible => true
  has_many :content_elements, :through => :page_content_element_assignments

  belongs_to :page_template

  def self.find_by_name(param)
    self.find_by_title_de(param)
  end

  lifecycle do
    state :draft, :default => true
    state :published, :published_but_hidden, :archived

    transition :publish, { [:draft, :archived] => :published}, :available_to => "User.administrator"
    transition :archive, { [:published, :published_but_hidden] => :archived }, :available_to => "User.administrator"
    transition :hide_from_menu, { :published => :published_but_hidden }, :available_to => "User.administrator"
    transition :show_in_menu, { :published_but_hidden => :published}, :available_to => "User.administrator"
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
