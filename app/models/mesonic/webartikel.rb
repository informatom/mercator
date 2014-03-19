class Mesonic::Webartikel < Mesonic::Sqlserver

  self.table_name = "WEBARTIKEL"
  self.primary_key = "Artikelnummer"

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  attr_accessible

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