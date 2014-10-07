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

  self.include_root_in_json = true

  default_scope { order('countries.name_de ASC') }

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
    find_by_name_de(param)
  end
end