class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name   :string
    number :string
    timestamps
  end
  attr_accessible :name, :number, :photo, :document

  has_paper_trail
  has_attached_file :photo,
    :styles => { :large => "1000x1000>", :medium => "500x500>", :small => "250x250>",
                 :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :document, :default_url => "/images/:style/missing.png"

  lifecycle do
    state :new, :default => true
    state :announced, :active, :deprecated
    transition :activate, {:new => :active}, :available_to => "User.administrator"
    transition :announce, {:new => :announced}, :available_to => "User.administrator"
    transition :release, {:announced => :active}, :available_to => "User.administrator"
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
