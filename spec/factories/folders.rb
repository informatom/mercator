# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :folder do
    name     "texts"
    ancestry nil
    position 1
  end
end
