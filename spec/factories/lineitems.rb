# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lineitem do
    position       123
    product_number "nr123"
    description_de "Artikel Eins Zwei Drei"
    description_en "Article One Two Three"
    amount         42
    product_price  123.45
    vat            20
    value          5184.90
  end
end
