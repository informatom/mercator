FactoryGirl.define do

  factory :contractitem do
    contract
    monitoring_rate  6
    startdate        Date.new(2015, 8, 3)
    position         123
    product
    product_number   "nr123"
    product_title    "Artikel Eins Zwei Drei"
    amount           42
    vat              20
    volume_bw        10000
    volume_color     5000
    marge            10

    factory :second_contractitem do
      startdate        Date.new(2016, 1, 1)
      monitoring_rate  5
      position         12
      product
      product_number   "second_product_number"
      product_title    "Zweiter Artikel"
      amount           12
      vat              10
      volume_bw        7000
      volume_color     4000
      marge            8
    end
  end
end