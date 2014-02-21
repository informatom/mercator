# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer do
    user
    association :consultant, factory: :sales
    billing_name "Max Mustermann"
    billing_detail "persönlich"
    billing_street "Musterstraße 123"
    billing_postalcode "1234"
    billing_city "Musterstadt"
    billing_country "Österreich"
    shipping_name "Max Mustermann"
    shipping_detail "persönlich"
    shipping_street "Musterstraße 123"
    shipping_postalcode "1234"
    shipping_city "Musterstadt"
    shipping_country "Österreich"
    valid_until   "1.1.2113"
  end
end
