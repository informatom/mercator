FactoryGirl.define do

  factory :order do
    user
    billing_method "Rechnung"
    billing_name "Max Mustermann"
    billing_detail "persönlich"
    billing_street "Musterstraße 123"
    billing_postalcode "1234"
    billing_city "Musterstadt"
    billing_country "Österreich"
    shipping_method "Postversand"
    shipping_name "Max Mustermann"
    shipping_detail "persönlich"
    shipping_street "Musterstraße 123"
    shipping_postalcode "1234"
    shipping_city "Musterstadt"
    shipping_country "Österreich"
  end

end