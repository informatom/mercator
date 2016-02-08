FactoryGirl.define do
  sequence :erp_identifier do |n|
    n.to_s
  end

  factory :price do
    inventory
    value      42
    vat        20
    valid_from "1.1.2012"
    valid_to   "1.1.2113"
    scale_from 1
    scale_to   6
    promotion  true
    erp_identifier

    factory :reduced_price do
      inventory nil
      value 38
      scale_from 7
      scale_to 100
      vat 10
      erp_identifier
    end

    factory :lower_price do
      inventory nil
      value 38
      scale_from 1
      scale_to 100
      erp_identifier
    end
  end
end