require 'spec_helper'

describe Order do
  it "is valid with billing_method, billing_gender, billing_title, billing_first_name," +
     "billing_surname, billing_company, billing_detail, billing_street, billing_postalcode, " +
     "billing_city, billing_country, billing_phone, shipping_method, shipping_gender, " +
     "shipping_first_name, shipping_surname, shipping_company, shipping_detail, shipping_street," +
     "shipping_postalcode, shipping_city, shipping_country, shipping_phone, store, gtc_confirmed_at," +
     "gtc_version_of, erp_customer_number, erp_billing_number, erp_order_number, discount_rel" do
    expect(build :order).to be_valid
  end

  it {should belong_to :user}
  it {should validate_presence_of :user}

  it {should have_many :lineitems}
  it {should belong_to :conversation}

  it "is versioned" do
    is_expected.to respond_to :versions
  end
end