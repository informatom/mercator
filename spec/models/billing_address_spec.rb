require 'spec_helper'

describe BillingAddress do
  it "is valid with name, detail, street, postal code, city" do
    expect(build(:billing_address)).to be_valid
  end

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:street)}
  it {should validate_presence_of(:postalcode)}
  it {should validate_presence_of(:city)}
  it {should validate_presence_of(:country)}

  it {should belong_to(:user)}
  it {should validate_presence_of(:user_id)}

  it "is versioned" do
    should respond_to(:versions)
  end
end