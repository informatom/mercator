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

    factory :offeritem_two do
      position       2
      association :product, factory: :second_product
      product_number "2"
      description_de "Zwei"
      description_en "Two"
      amount         2
      unit           "Paare"
      product_price  2
      vat            2
      value          2
      delivery_time  "2 Wochen"
    end
  end
end