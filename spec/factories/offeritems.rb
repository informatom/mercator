# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offeritem do
    offer
    user           {offer.user}
    position       123
    product
    product_number "nr123"
    description_de "Artikel Eins Zwei Drei"
    description_en "Article One Two Three"
    amount         42
    unit           "Stück"
    product_price  123.45
    vat            20
    value          5184.90
    delivery_time  "One week"
  end
end
