class Legacy::Content < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'contents'

  has_many :connectors
end