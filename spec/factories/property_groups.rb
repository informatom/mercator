FactoryGirl.define do
  factory :property_group do
    product
    name_de  "Ich bin der deutsche Titel"
    name_en  "I Am the English Title"
    position 42
  end
end