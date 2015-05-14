FactoryGirl.define do

  factory :price do
    inventory
    value      42
    vat        20
    valid_from "1.1.2012"
    valid_to   "1.1.2113"
    scale_from 1
    scale_to   6
    promotion  true

    factory :reduced_price do
      inventory nil
      value 38
      scale_from 7
      scale_to 100
    end

    factory :lower_price do
      inventory nil
      value 38
      scale_from 1
      scale_to 100
    end
  end
end