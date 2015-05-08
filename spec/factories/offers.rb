FactoryGirl.define do

  factory :offer do
    user
    association :consultant, factory: :sales
    billing_company      "Bigcorp"
    billing_gender       "Mr."
    billing_title        "Dr."
    billing_first_name         "Max"
    billing_surname      "Mustermann"
    billing_detail       "Finanzabteilung"
    billing_street       "Musterstraße 123"
    billing_postalcode   "1234"
    billing_city         "Musterstadt"
    billing_country      "Österreich"
    billing_phone        "+43123456789"
    shipping_company     "Bigcorp"
    shipping_gender      "Mr."
    shipping_title       "Dr."
    shipping_first_name  "Max"
    shipping_surname     "Mustermann"
    shipping_detail      "Finanzabteilung"
    shipping_street      "Musterstraße 123"
    shipping_postalcode  "1234"
    shipping_city        "Musterstadt"
    shipping_country     "Österreich"
    shipping_phone       "+43123456789"
    valid_until          "1.1.2113"
    complete             true
    discount_rel         1.23
  end
end