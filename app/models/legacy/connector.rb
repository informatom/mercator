class Legacy::Connector < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'connectors'

  belongs_to :content
  belongs_to :cms_node
end