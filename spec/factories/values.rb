FactoryGirl.define do

  factory :value do
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
end