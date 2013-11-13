class Address < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name       :string, :required
    detail     :string
    street     :string, :required
    postalcode :string, :required
    city       :string, :required
    timestamps
  end
  attr_accessible :user_id, :name, :detail, :street, :postalcode, :city, :user

  belongs_to :user
  validates_presence_of :user

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
    ( acting_user == self.user ) || acting_user.administrator?
  end

end