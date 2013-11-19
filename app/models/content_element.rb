class ContentElement < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de    :string, :required, :unique
    name_en    :string
    markup     enum_string(:html, :markdown, :name => "markup")
    content_de :cktext, :required
    content_en :cktext
    timestamps
  end

  attr_accessible :name_de, :name_en, :content_de, :content_en, :markup
  translates :name, :content
  has_paper_trail

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