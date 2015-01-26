class Logentry < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    severity :string
    message  :string
    timestamps
  end
  attr_accessible :severity, :message, :user_id, :user

  belongs_to :user

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
