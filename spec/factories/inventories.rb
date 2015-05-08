FactoryGirl.define do

  factory :inventory do
    product
    name_de                 "Halbschuh Größe 37"
    name_en                 "Slipper Size 8"
    number                  "slip-42"
    amount                  42
    unit                    "Stk."
    comment_de              "in 3 Wochen lieferbar"
    comment_en              "available in 3 weeks"
    weight                  0.5
    charge                  "ABC42"
    storage                 "Filiale 1"
    delivery_time           "2 Wochen"
    erp_updated_at          "2014-01-22 15:23"
    erp_vatline             20
    erp_article_group       17
    erp_provision_code      42
    erp_characteristic_flag 42
    infinite                true
    just_imported           true
    alternative_number      "slip-4-2"
  end
end