FactoryGirl.define do

  factory :address do
    user
    first_name "John"
    surname    "Doe"
    c_o        "in person"
    detail     "Department of Despair"
    street     "Kärntner Straße 123"
    postalcode "1234"
    city       "Vienna"
    country    "Österreich"
  end
end