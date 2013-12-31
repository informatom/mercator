require 'spec_helper'

describe Toner do
  it "is valid with article_number, description, vendor_number, price" do
    expect(build(:toner)).to be_valid
  end

  it {should validate_presence_of :vendor_number}
  it {should validate_presence_of :price}

  it "is versioned" do
    should respond_to(:versions)
  end
end