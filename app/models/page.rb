class Page < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de :string, :required
    title_en :string
    timestamps
  end
  attr_accessible :title_de, :title_en, :page_elements, :content_elements

  translates :title

  has_paper_trail

  has_many :page_elements, :accessible => true
  has_many :content_elements, :through => :page_elements,
           :source => :usage, :source_type => 'ContentElement'

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
