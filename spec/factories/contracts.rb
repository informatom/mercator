FactoryGirl.define do

  factory :contract do
    contractnumber   "first contract number"
    term             36
    startdate        Date.new(2014, 3, 6)
    customer         "Max Mustermann"
    customer_account "an account number"
    monitoring_rate  5

    factory :second_contract do
      contractnumber   "second contract number"
      term 12
      startdate Date.new(2015, 8, 4)
      customer         "John Doe"
      customer_account "another account number"
      monitoring_rate  6
    end
  end
end