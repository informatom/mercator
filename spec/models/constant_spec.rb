require 'spec_helper'

describe Constant do
  it "is valid with key and value" do
    expect(build(:constant)).to be_valid
  end

  it {should validate_presence_of(:key)}
  it {should validate_uniqueness_of(:key)}

  it "should be versioned" do
    should respond_to(:versions)
  end
end