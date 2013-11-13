FactoryGirl.define do
  factory :property do
    pr = FactoryGirl.create(:product)
    property_group {FactoryGirl.create(:property_group, product: pr)}
    product {pr}
    name_de  "Ich bin der deutsche Titel"
    name_en  "I Am the English Title"
    description_de "Deutsch: Lorem ipsum dolor sit amet."
    description_en "English: Lorem ipsum dolor sit amet."
    value 42
    unit_de "kg"
    unit_en "kg"
  end
end