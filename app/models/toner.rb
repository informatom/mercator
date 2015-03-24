class Toner < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    article_number :string
    description    :string
    vendor_number  :string, :required, :name => true
    price          :decimal, :required, :precision => 13, :scale => 5
    timestamps
  end

  attr_accessible :article_number, :description, :vendor_number, :price, :xls

  has_paper_trail

  has_many :contractitems

# Attr Acessors for File Upload
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