# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contractitem do
    contract
    user           {contract.customer}
    position       123
    product
    product_number "nr123"
    description_de "Artikel Eins Zwei Drei"
    description_en "Article One Two Three"
    amount         42
    unit           "Stück"
    product_price  123.45
    vat            20
    value          45632
    discount_abs   3
    toner
    volume         10000
  end
end
