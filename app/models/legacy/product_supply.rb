class Legacy::ProductSupply < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'product_supplies'
end