FactoryGirl.define do

  factory :value do
    state "numeric"
    title_de "Deutscher Wert"
    title_en "English Value"
    amount   42
    unit_de "kg"
    unit_en "kg"
    flag    true
    product
    property
    property_group
  end

  factory :flag_value, class: Value do
    state "flag"
    flag  true
  end

  factory :numeric_value, class: Value do
    state   "numeric"
    amount  13
    unit_de "kg"
    unit_en "kg"
  end

  factory :textual_value, class: Value do
    state     "textual"
    title_de  "text value text"
    title_en  "text value text"

    factory :second_value do
      title_de "zweiter Wert"
      title_en "second Value"
    end

    factory :third_value do
      title_de "dritter Wert"
      title_en "third Value"
    end

    factory :fourth_value do
      title_de "vierter Wert"
      title_en "fourth Value"
    end
  end
end