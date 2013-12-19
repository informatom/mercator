class Toner < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    article_number :string
    description    :string
    vendor_number  :string
    price          :decimal, :precision => 10, :scale => 2
    timestamps
  end
  attr_accessible :article_number, :description, :vendor_number, :price, :xls

  def xls
    @xls
  end

  def xls=(val)
    @xls= val
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
