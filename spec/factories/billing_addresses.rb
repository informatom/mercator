# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :billing_address do
    user
    name "John Dde"
    detail "in person"
    street "Kärntner Straße 123"
    postalcode "1234"
    city "Vienna"
    country "Österreich"
    email_address "john.doe@informatom.com"
    vat_number "ATU66331917"
  end
end
