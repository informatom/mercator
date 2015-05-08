FactoryGirl.define do

  factory :contract do
    startdate "2.3.2014"
    runtime 36

    association :customer, factory: :user
    association :consultant, factory: :sales
  end
end