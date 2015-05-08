FactoryGirl.define do

  factory :consumableitem do
    contractitem
    position        1
    product_number  {build(:product).number}
    contract_type   "standard"
    product_line    "shiny"
    description_de  "ein Verbrauchsmaterial"
    description_en  "a consumaeble item"
    amount          1
    theyield        12000
    wholesale_price 12.50
    term            2
    consumption1    3
    consumption2    4
    consumption3    5
    consumption4    6
    consumption5    7
    consumption6    8
    balance6        99.99
  end
end
