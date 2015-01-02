class ContentElement < ActiveRecord::Base

  hobo_model # Don't put anything above this
  MarkupType = HoboFields::Types::EnumString.for("html", "markdown", "textile")

  fields do
    name_de    :string, :unique, :required
    name_en    :string
    markup     ContentElement::MarkupType
    content_de :cktext
    content_en :cktext
    legacy_id   :integer
    timestamps
  end

  attr_accessible :name_de, :name_en, :content_de, :content_en, :markup, :folder, :folder_id,
                  :webpages, :page_content_element_assignments, :legacy_id, :photo, :document
  translates :name, :content
  has_paper_trail

  alias_attribute :recid, :id

  default_scope { order('content_elements.name_de ASC') }

  has_attached_file :document, :default_url => "/images/:style/missing.png"
  has_attached_file :photo,
    :styles => { :medium => "500x500>", :small => "250x250>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  do_not_validate_attachment_file_type :document
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_many :page_content_element_assignments
  has_many :webpages, :through => :page_content_element_assignments

  belongs_to :folder, :accessible => true
  validates :folder, :presence => true

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator? ||
    acting_user.contentmanager?
  end

  def update_permitted?
    acting_user.administrator? ||
    acting_user.contentmanager?
  end

  def destroy_permitted?
    acting_user.administrator? ||
    acting_user.contentmanager?
  end

  def view_permitted?(field)
    true
  end

  # --- Class Methods --- #
  def self.find_by_name(param)
    find_by_name_de(param)
  end

  def self.image(name: nil)
    find_by(name_de: name).try(:photo) || find_by(name_en: name).try(:photo)
  end

  # --- Instance Methods --- #
  def thumb_url
    photo.url(:small)
  end

  def photo_url
    photo.url
  end

  def parse
    return nil unless self.content

    case self.markup
    when "html"
      html_content = self.content
    when "textile"
      html_content = RedCloth.new(self.content).to_html
    when "markdown"
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      html_content = markdown.render(self.content)
    end

    # Parsing images in...
    html_fragment = Nokogiri::HTML.fragment(html_content)

    photos = html_fragment.css "photo"
    photos.each do |photo|

      photo_content_element = ContentElement.find_by(name_de: photo['name'])
      photo_content_element ||= ContentElement.find_by(name_en: photo['name'])

      if photo_content_element
        photo.name = 'img'
        if photo['size']
          photo['src'] = photo_content_element.photo(photo['size'].to_sym)
          photo['size'] = nil
        else
          photo['src']= photo_content_element.photo
        end
      end
    end

    documents = html_fragment.css "document"
    documents.each do |document|

      document_content_element = ContentElement.find_by(name_de: document['name'])
      document_content_element ||= ContentElement.find_by(name_en: document['name'])

      if document_content_element
        document.name = 'a'
        document['href']= document_content_element.document.url
        document.content= document_content_element.document_file_name
      end
    end

    html_fragment.to_html.html_safe
  end
end