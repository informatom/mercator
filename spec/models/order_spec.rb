require 'spec_helper'

describe Order do
  it "is valid with billing_method, billing_name, billing_detail, billing_street,
      billing_postalcode, billing_city, billing_country, shipping_method, shipping_name,
      shipping_detail, shipping_street, shipping_postalcode, shipping_city, shipping_country" do
    expect(build(:order)).to be_valid
  end

  it {should validate_presence_of(:user)}

  it {should validate_presence_of(:billing_method)}
  it {should validate_presence_of(:billing_name)}
  it {should validate_presence_of(:billing_street)}
  it {should validate_presence_of(:billing_postalcode)}
  it {should validate_presence_of(:billing_city)}
  it {should validate_presence_of(:billing_country)}

  it {should validate_presence_of(:shipping_method)}
  it {should validate_presence_of(:shipping_name)}
  it {should validate_presence_of(:shipping_street)}
  it {should validate_presence_of(:shipping_postalcode)}
  it {should validate_presence_of(:shipping_city)}
  it {should validate_presence_of(:shipping_country)}

  it {should have_many(:lineitems)}

  it "is versioned" do
    should respond_to(:versions)
  end
end