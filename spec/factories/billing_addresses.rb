FactoryGirl.define do

  factory :billing_address do
    user
    company       "Bigcorp"
    gender        "male"
    title         "Dr"
    first_name    "John"
    surname       "Doe"
    email_address "john.doe@informatom.com"
    detail        "Department of Despair"
    street        "Kärntner Straße 123"
    postalcode    "1234"
    city          "Vienna"
    country       "Österreich"
    phone         "+43123456789"
    vat_number    "ATU66331917"
  end
end