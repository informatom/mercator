FactoryGirl.define do

  factory :recommendation do
    reason_de   "Fantastisches Produkt"
    reason_en   "Fantastic Product"
    product
    association :recommended_product, factory: :second_product
  end
end