FactoryGirl.define do

  factory :contract do
    startdate Date.new(2014, 3, 6)
    term 36

    association :customer, factory: :user
    association :consultant, factory: :sales
  end
end