# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature do
    position 1
    text_de "Ich bin ein Feature"
    text_en "I am a feature"
    product
  end
end
