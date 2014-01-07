class Legacy::ContentItem < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'content_items'

  belongs_to :content
end