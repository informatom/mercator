class Legacy::ProductProperty < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'products_properties'

  belongs_to :product
  belongs_to :property
end