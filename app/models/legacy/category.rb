class Legacy::Category < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'categories'

  # The following two lines fix the migration issues
  hobo_model
  fields

  has_many :category_translations
end