class Legacy::ProductTranslation < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'product_translations'

  belongs_to :product
  scope :german, -> { where(locale: "de") }
  scope :english, -> { where(locale: "en") }
end
