class Chapter < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    start :string, :required
    title :string, :required
    href  :string
    timestamps
  end
  attr_accessible :start, :title, :href

  belongs_to :podcast

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