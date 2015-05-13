FactoryGirl.define do

  factory :shipping_cost do
    value           42
    vat             20
    shipping_method "parcel_service_shipment"
    country

    factory :country_unspecific_shipping_cost do
      country nil
    end
  end
end