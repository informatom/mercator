class Legacy::Attachable < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'attachables'

  belongs_to :asset
end