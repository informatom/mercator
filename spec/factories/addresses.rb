FactoryGirl.define do

  factory :address do
    user
    company    "Bigcorp"
    gender     "male"
    title      "Dr"
    first_name "John"
    surname    "Doe"
    detail     "Department of Despair"
    street     "Kärntner Straße 123"
    postalcode "1234"
    city       "Vienna"
    country    "Österreich"
    phone      "+43123456789"

    factory :second_address do
        company    "small corp"
        gender     "female"
        title      "Mga"
        first_name "Jane"
        surname    "Done"
        detail     "Department of Hope"
        street     "Sesame Street 1"
        postalcode "5678"
        city       "Graz"
        country    "Österreich"
        phone      "+4311111111"
    end
  end
end