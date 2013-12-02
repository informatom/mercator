class Legacy::User < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'ivellio_vellin_customers'
end