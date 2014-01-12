require 'spec_helper'

describe User do
  it "is valid with a name, email_address but without administrator" do
    expect(build(:user)).to be_valid
  end

  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:name)}
  it {should have_many(:addresses)}
  it {should have_one(:billing_address)}
  it {should have_many(:orders)}

  it "is valid with a name, email_address and administrator" do
    expect(build(:admin)).to be_valid
  end

  it "is versioned" do
    should respond_to(:versions)
  end
end