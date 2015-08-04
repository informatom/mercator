FactoryGirl.define do

  factory :contractitem do
    contract
    user             {contract.customer}
    startdate        Date.new(2015, 8, 3)
    position         123
    product
    product_number   "nr123"
    description_de   "Artikel Eins Zwei Drei"
    description_en   "Article One Two Three"
    amount           42
    unit             "Stück"
    product_price    123.45
    vat              20
    value            45632
    discount_abs     3
    term             12
    toner
    volume_bw        10000
    volume_color     5000
    marge            10
    monitoring_rate  5

    factory :second_contractitem do
      startdate        Date.new(2016, 1, 1)
      position         12
      product
      product_number   "second_product_number"
      description_de   "Zweiter Artikel"
      description_en   "Second Article"
      amount           12
      unit             "Liter"
      product_price    12.3
      vat              10
      value            321
      discount_abs     4
      term             24
      toner
      volume_bw        7000
      volume_color     4000
      marge            8
      monitoring_rate  6
    end
  end
end