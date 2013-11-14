class ContentElement < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de    :string, :required, :unique
    content_de :cktext, :required
    markup     :string
    name_en    :string
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