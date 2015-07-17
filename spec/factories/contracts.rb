FactoryGirl.define do

  factory :contract do
    term      36
    startdate Date.new(2014, 3, 6)

    association :customer, factory: :user
    association :consultant, factory: :sales
  end
end