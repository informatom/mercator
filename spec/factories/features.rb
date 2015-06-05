FactoryGirl.define do

  factory :feature do
    position 1
    text_de  "Ich bin ein Feature"
    text_en  "I am a feature"
    product

    factory :first_feature do
      position 1
      text_de "erstes Feature"
      text_en "first feature"
    end

    factory :second_feature do
      position 2
      text_de "zweites Feature"
      text_en "second feature"
    end
  end
end