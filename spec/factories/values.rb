# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :value do
    title_de "Deutsch: Lorem ipsum dolor sit amet."
    title_en "English: Lorem ipsum dolor sit amet."
    amount   42
    unit_de "kg"
    unit_en "kg"
    flag    true
    product
    property
    property_group
  end
end
