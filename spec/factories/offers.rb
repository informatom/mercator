# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer do
    user
    association :consultant, factory: :sales
    billing_name         "Max Mustermann"
    billing_c_o          "persönlich"
    billing_detail       "Finanzabteilung"
    billing_street       "Musterstraße 123"
    billing_postalcode   "1234"
    billing_city         "Musterstadt"
    billing_country      "Österreich"
    shipping_name        "Max Mustermann"
    shipping_c_o         "persönlich"
    shipping_detail      "Finanzabteilung"
    shipping_street      "Musterstraße 123"
    shipping_postalcode  "1234"
    shipping_city        "Musterstadt"
    shipping_country     "Österreich"
    valid_until          "1.1.2113"
    complete             true
    discount_rel         1.23
  end
end
