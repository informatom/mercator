class Category < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de     :string, :required
    name_en     :string
    ancestry :string, :index => true
    position :integer
    timestamps
  end
  attr_accessible :name_de, :name_en, :ancestry, :position, :active, :parent_id

  translates :name
  has_ancestry
  has_paper_trail

  lifecycle do
    state :new, :default => true
    state :active, :deprecated

    transition :activate, {:new => :active}, :available_to => "User.administrator"
    transition :deactivate, { :active => :deprecated }, :available_to => "User.administrator"
    transition :reactivate, { :deprecated => :active }, :available_to => "User.administrator"
  end

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
