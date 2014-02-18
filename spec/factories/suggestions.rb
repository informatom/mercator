# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :suggestion do
    conversation
    product
  end
end
