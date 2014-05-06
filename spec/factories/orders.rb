FactoryGirl.define do

  factory :order do
    user
    billing_method      "Rechnung"
    billing_name        "Max Mustermann"
    billing_c_o         "persönlich"
    billing_detail      "Finanzabteilung"
    billing_street      "Musterstraße 123"
    billing_postalcode  "1234"
    billing_city        "Musterstadt"
    billing_country     "Österreich"
    shipping_method     "Postversand"
    shipping_name       "Max Mustermann"
    shipping_c_o        "persönlich"
    shipping_detail     "Finanzabteilung"
    shipping_street     "Musterstraße 123"
    shipping_postalcode "1234"
    shipping_city       "Musterstadt"
    shipping_country    "Österreich"
    gtc_confirmed_at    "2014-01-22 12:23"
    gtc_version_of      "2014-01-22"
    erp_customer_number "a123"
    erp_billing_number  "b123"
    erp_order_number    "o123"
  end

end