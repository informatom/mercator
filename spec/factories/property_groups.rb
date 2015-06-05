FactoryGirl.define do

  factory :property_group do
    name_de   "Eigenschaftengruppe"
    name_en   "property group"
    position  42
    icecat_id 42

    factory :second_property_group do
      name_de "2. Eigenschaftengruppe"
      name_en "2. property group"
      position 43
    end
  end
end