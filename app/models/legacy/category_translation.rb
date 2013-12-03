class Legacy::CategoryTranslation < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'category_translations'

  belongs_to :category
  scope :german, -> { where(locale: "de") }
  scope :english, -> { where(locale: "en") }
end