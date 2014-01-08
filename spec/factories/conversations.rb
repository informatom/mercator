# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    name "Nette Unterhaltung"
    association :customer, factory: :user
    association :consultant, factory: :sales
  end
end
