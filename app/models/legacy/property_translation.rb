class Legacy::PropertyTranslation < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'property_translations'

  belongs_to :property
  scope :german, -> { where(locale: "de") }
  scope :english, -> { where(locale: "en") }
end