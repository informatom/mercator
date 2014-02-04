class Country < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de :string, :required, :unique
    name_en :string, :required, :unique
    code    :string, :required, :unique
    legacy_id :integer
    timestamps
  end
  attr_accessible :name, :name_de, :name_en, :code, :legacy_id
  translates :name
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

  #--- Class Methods --- #

  def self.find_by_name(param)
    self.find_by_name_de(param)
  end
end