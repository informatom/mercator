class Legacy::Recommendation < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'recommendations'

  # The following two lines fix the migration issues
  hobo_model
  fields

  has_many :recommendation_translations
end