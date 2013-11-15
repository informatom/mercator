FactoryGirl.define do

  factory :property do
    property_group
    product {property_group.product}
    name_de  "Ich bin der deutsche Titel"
    name_en  "I Am the English Title"
    description_de "Deutsch: Lorem ipsum dolor sit amet."
    description_en "English: Lorem ipsum dolor sit amet."
    value 42
    unit_de "kg"
    unit_en "kg"
  end

end