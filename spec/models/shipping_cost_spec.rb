require 'spec_helper'

describe ShippingCost do
  it "is valid with shipping_method, country, value" do
    expect(build(:shipping_cost)).to be_valid
  end

  it {should validate_presence_of(:value)}
  it {should validate_presence_of(:shipping_method)}
  it {should belong_to(:country)}

  it "is versioned" do
    should respond_to(:versions)
  end
end
