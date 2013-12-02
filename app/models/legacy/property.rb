class Legacy::Property < ActiveRecord::Base
  establish_connection "import_development"
# Commented because migration generator gets confused
  self.table_name = 'properties'

  has_many :property_translations

  has_many :product_properties
  has_many :products, :through => :product_properties
end