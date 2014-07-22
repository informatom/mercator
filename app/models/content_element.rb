class ContentElement < ActiveRecord::Base

  hobo_model # Don't put anything above this
  MarkupType = HoboFields::Types::EnumString.for("html", "markdown")

  fields do
    name_de    :string, :unique, :required
    name_en    :string
    markup     ContentElement::MarkupType
    content_de :cktext, :required
    content_en :cktext
    legacy_id   :integer
    timestamps
  end

  attr_accessible :name_de, :name_en, :content_de, :content_en, :markup,
                  :webpages, :page_content_element_assignments, :legacy_id, :photo, :document
  translates :name, :content
  has_paper_trail

  default_scope { order('content_elements.name_de ASC') }

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  do_not_validate_attachment_file_type :document
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_many :page_content_element_assignments, :accessible => true
  has_many :webpages, :through => :page_content_element_assignments

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