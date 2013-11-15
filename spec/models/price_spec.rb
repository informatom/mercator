require 'spec_helper'

describe Price do
  it "is valid with value, vat, valid_from, valid_to, scale_from, scale_to" do
    expect(build(:price)).to be_valid
  end

  it {should validate_presence_of(:value)}
  it {should validate_presence_of(:vat)}

  it {should belong_to(:inventory)}
  it {should validate_presence_of(:inventory)}

  it "is versioned" do
    should respond_to(:versions)
  end
end
