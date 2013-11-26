FactoryGirl.define do

  factory :price do
    inventory
    value      42
    vat        20
    valid_from "1.1.1013"
    valid_to   "1.1.2113"
    scale_from 1
    scale_to   100
  end

end