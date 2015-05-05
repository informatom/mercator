require 'spec_helper'

describe Address do
  it "is valid with first_name, surname, c_o, detail, street, postal code, city, country" do
    build(:country).save
    expect(build(:address)).to be_valid
  end

  it {should validate_presence_of(:first_name)}
  it {should validate_presence_of(:surname)}
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