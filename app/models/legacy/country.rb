class Legacy::Country < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'zones'
end