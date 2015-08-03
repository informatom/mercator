FactoryGirl.define do

  factory :contractitem do
    contract
    user            {contract.customer}
    startdate       Date.new(2015, 8, 3)
    position        123
    product
    product_number  "nr123"
    description_de  "Artikel Eins Zwei Drei"
    description_en  "Article One Two Three"
    amount          42
    unit            "Stück"
    product_price   123.45
    vat             20
    value           45632
    discount_abs    3
    term            12
    toner
    volume_bw       10000
    volume_color    5000
    marge           10
    monitoring_rate  5
  end
end