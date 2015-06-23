FactoryGirl.define do

  factory :order do
    user
    billing_method      "e_payment"
    billing_gender      "male"
    billing_title       "Dr"
    billing_first_name  "Max"
    billing_surname     "Mustermann"
    billing_company     "Bigcorp"
    billing_detail      "Finanzabteilung"
    billing_street      "Musterstraße 123"
    billing_postalcode  "1234"
    billing_city        "Musterstadt"
    billing_country     "Österreich"
    billing_phone       "+43123456789"
    shipping_method     "parcel_service_shipment"
    shipping_gender     "male"
    shipping_title      "Dr."
    shipping_first_name "Max"
    shipping_surname    "Mustermann"
    shipping_company    "Bigcorp"
    shipping_detail     "Finanzabteilung"
    shipping_street     "Musterstraße 123"
    shipping_postalcode "1234"
    shipping_city       "Musterstadt"
    shipping_country    "Österreich"
    shipping_phone      "+43123456789"
    store               "Store A"
    gtc_confirmed_at    "2014-01-22 12:23"
    gtc_version_of      "2014-01-22"
    erp_customer_number "a123"
    erp_billing_number  "b123"
    erp_order_number    "o123"
    discount_rel        "2.5"

    factory :basket

    factory :parked_basket do
      state "parked"
    end

    factory :order_in_payment do
      state "in_payment"
    end
  end
end