require 'spec_helper'

describe Order do
  it "is valid with billing_method, billing_name, billing_detail, billing_street,
      billing_postalcode, billing_city, billing_country, shipping_method, shipping_name,
      shipping_detail, shipping_street, shipping_postalcode, shipping_city, shipping_country" do
    expect(build(:order)).to be_valid
  end

 # it {should validate_presence_of(:user)}

  it {should belong_to(:user)}
  it {should have_many(:lineitems)}
  it {should belong_to(:conversation)}

  it "is versioned" do
    should respond_to(:versions)
  end
end