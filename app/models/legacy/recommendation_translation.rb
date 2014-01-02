class Legacy::RecommendationTranslation < ActiveRecord::Base
  establish_connection "import_development"
  self.table_name = 'recommendation_translations'

  belongs_to :recommendation
  scope :german, -> { where(locale: "de") }
  scope :english, -> { where(locale: "en") }
end
