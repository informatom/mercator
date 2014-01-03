class PageTemplate < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name    :string, :required, :unique
    content :text, :required
    legacy_id :integer
    timestamps
  end
  attr_accessible :name, :content, :legacy_id
  
  has_paper_trail

  has_many :pages

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
