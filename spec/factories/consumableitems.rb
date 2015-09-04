FactoryGirl.define do

  factory :consumableitem do
    contractitem
    position        1
    product_number  {build(:product).number}
    contract_type   "standard"
    product_line    "shiny"
    product_title   "ein Verbrauchsmaterial"
    amount          1
    theyield        12000
    wholesale_price 12.50
    term            2
    consumption1    3
    consumption2    4
    consumption3    5
    consumption4    6
    consumption5    7

    factory :second_consumableitem do
      position        2
      product_number  "another product number"
      contract_type   "alternative"
      product_line    "brass"
      product_title   "ein anderes Verbrauchsmaterial"
      amount          2
      theyield        1200
      wholesale_price 32.40
      term            12
      consumption1    5
      consumption2    4
      consumption3    3
      consumption4    2
      consumption5    1
    end
  end
end
