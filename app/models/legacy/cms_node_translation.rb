class Legacy::CmsNodeTranslation < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'cms_node_translations'

  belongs_to :cms_node
  scope :german, -> { where(locale: "de") }
  scope :english, -> { where(locale: "en") }
end