class Contract < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    runtime   :integer
    startdate :date
    timestamps
  end
  attr_accessible :runtime, :startdate

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
