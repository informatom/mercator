FactoryGirl.define do

  factory :conversation do
    name        "Freudliche Beratung"
    association :customer, factory: :user
    association :consultant, factory: :sales
  end
end