class Legacy::CmsNode < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'cms_nodes'

  has_many :cms_node_translations
  has_many :connectors
end