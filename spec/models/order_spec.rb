require 'spec_helper'

describe Order do
  it "is valid with billing_method, billing_name, billing_c_o, billing_detail,
      billing_street, billing_postalcode, billing_city, billing_country,
      shipping_method, shipping_name, shipping_c_o, shipping_detail, shipping_street,
      shipping_postalcode, shipping_city, shipping_country, gtc_confirmed_at,
      gtc_version_of, erp_customer_number, erp_billing_number, erp_order_number" do
    expect(build(:order)).to be_valid
  end

  it {should belong_to(:user)}
  it {should validate_presence_of(:user)}

  it {should have_many(:lineitems)}
  it {should belong_to(:conversation)}

  it "is versioned" do
    should respond_to(:versions)
  end
end