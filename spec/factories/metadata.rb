FactoryGirl.define do

  factory :metadatum, :class => 'MercatorIcecat::Metadatum' do
    product
    path              "export/freexml.int/INT/31543323.xml"
    icecat_updated_at { Time.now - 1.month }
    quality           "SUPPLIER"
    supplier_id       "1"
    icecat_product_id "1286"
    prod_id           "H2872E"
    product_number    nil
    cat_id            "156"
    on_market         "1"
    icecat_model_name "netserver lh 6000 pIII-x/700 MHz 256M pedestal 1m cache"
    product_view      "11867"
  end

  factory :second_metadatum, :class => 'MercatorIcecat::Metadatum' do
    path              "export/freexml.int/INT/25880804.xml"
    icecat_updated_at { Time.now - 1.month }
    quality           "ICECAT"
    supplier_id       "1"
    icecat_product_id "25880804"
    prod_id           "K9J77EA"
    product_number    nil
    cat_id            "151"
    on_market         "1"
    icecat_model_name "430 G2"
    product_view      "6915"
  end
end