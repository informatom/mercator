class ContentElement < ActiveRecord::Base

  hobo_model # Don't put anything above this
  MarkupType = HoboFields::Types::EnumString.for("html", "markdown")

  fields do
    name_de    :string, :required, :unique
    name_en    :string
    markup     ContentElement::MarkupType
    content_de :cktext, :required
    content_en :cktext
    timestamps
  end

  attr_accessible :name_de, :name_en, :content_de, :content_en, :markup,
                  :pages, :page_content_element_assignments
  translates :name, :content
  has_paper_trail

  has_many :page_content_element_assignments, :accessible => true
  has_many :pages, :through => :page_elements

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