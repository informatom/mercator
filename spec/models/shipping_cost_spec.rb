require 'spec_helper'

describe ShippingCost do
  it "is valid with shipping_method, country, value, vat" do
    expect(build :shipping_cost).to be_valid
  end

  it {should validate_presence_of :value}
  it {should validate_presence_of :vat}
  it {should validate_presence_of :shipping_method}

  it {should validate_numericality_of :value}
  it {should validate_numericality_of :vat}

  it {should belong_to :country}

  it "is versioned" do
    should respond_to :versions
  end
end
