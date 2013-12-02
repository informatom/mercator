class Legacy::Product < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'products'

  has_many :product_translations
  has_many :product_properties
  has_many :properties , :through => :product_properties
end