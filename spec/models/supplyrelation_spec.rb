require 'spec_helper'

describe Supplyrelation do
  it "is valid with product, supply" do
      expect(build :recommendation).to be_valid
  end

  it {should belong_to :product}
  it {should validate_presence_of :product}

  it {should belong_to :supply}
  it {should validate_presence_of :supply_id}
  it {should validate_uniqueness_of :supply_id}

  it "is versioned" do
    should respond_to :versions
  end
end