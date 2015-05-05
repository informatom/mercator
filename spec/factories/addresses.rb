FactoryGirl.define do

  factory :address do
    user
    company    "Bigcorp"
    title      "Dr"
    first_name "John"
    surname    "Doe"
    detail     "Department of Despair"
    street     "Kärntner Straße 123"
    postalcode "1234"
    city       "Vienna"
    country    "Österreich"
    phone      "+43123456789"
  end
end