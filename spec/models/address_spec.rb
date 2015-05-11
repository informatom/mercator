require 'spec_helper'

describe Address do
  it "is valid with company, title, first_name, surname, detail, street, postal code, city, " +
     "country, phone" do
    build(:country).save
    expect(build :address).to be_valid
  end

  it {should validate_presence_of :company}
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :surname}
  it {should validate_presence_of :street}
  it {should validate_presence_of :postalcode}
  it {should validate_presence_of :city}
  it {should validate_presence_of :country}

  it {should belong_to :user}
  it {should validate_presence_of :user}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


## Instance Methods

  context "if_country_exists" do
    it "return error for non-existing country" do
      @address = build(:address, country: "Wonderland")
      @address.if_country_exists
      expect(@address.errors.messages[:base]).to include("Unbekanntes Land")
    end

    it "return no error for existing country" do
      create(:country)

      @address = build(:address)
      @address.if_country_exists
      expect(@address.errors.messages[:base]).to be_nil
    end
  end
end