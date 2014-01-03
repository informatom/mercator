class Legacy::PageTemplate < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'page_templates'

  # The following two lines fix the migration issues
  hobo_model
  fields
end