FactoryGirl.define do

  factory :inventory do
    product
    name_de    "Halbschuh Größe 37"
    name_en    "Slipper Size 8"
    number     "slip-42"
    amount     42
    unit       "Stk."
    comment_de "in 3 Wochen lieferbar"
    comment_en "available in 3 weeks"
    weight     0.5
    charge     "ABC42"
    storage    "Filiale 1"
  end

end