class Gtc < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de   :string, :required, :name
    title_en   :string, :required
    content_de :cktext, :required
    content_en :cktext, :required
    version_of :date, :required
    timestamps
  end
  attr_accessible :title_de, :title_en, :content_de, :content_en, :version_of
  translates :title, :content
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
