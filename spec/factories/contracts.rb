FactoryGirl.define do

  factory :contract do
    contractnumber   "first contract number"
    startdate        Date.new(2014, 3, 6)
    customer         "Max Mustermann"
    customer_account "an account number"

    factory :second_contract do
      contractnumber   "second contract number"
      startdate Date.new(2015, 8, 4)
      customer         "John Doe"
      customer_account "another account number"
    end
  end
end