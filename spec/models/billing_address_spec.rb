require 'spec_helper'

describe BillingAddress do
  it "is valid with name, c_o, detail, street, postal code, city, country, vat_number" do
    expect(build(:billing_address)).to be_valid
  end

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:street)}
  it {should validate_presence_of(:postalcode)}
  it {should validate_presence_of(:city)}
  it {should validate_presence_of(:country)}

  it {should belong_to(:user)}
  it {should validate_presence_of(:user)}

  it "is versioned" do
    should respond_to(:versions)
  end
end
