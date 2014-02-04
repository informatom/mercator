# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_cost do
    value           42
    vat             20
    shipping_method "parcel_service_shipment"
    country
  end
end
