FactoryGirl.define do

  factory :property do
    name_de   "Eigenschaft"
    name_en   "property"
    position  1
    datatype  "textual"
    icecat_id 42

    factory :second_property do
      name_de "zweite Eigenschaft"
      name_en "second Property"
      position 2
    end

    factory :third_property do
      name_de "zweite Eigenschaft"
      name_en "dritte Property"
      position 3
    end

    factory :fourth_property do
      name_de "zweite Eigenschaft"
      name_en "vierte Property"
      position 4
    end
  end
end