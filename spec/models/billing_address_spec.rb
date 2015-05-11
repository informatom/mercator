require 'spec_helper'

describe BillingAddress do
  it "is valid with company, title, first_name, surname, email_address, detail, street," +
     "postal code, city, country, phone vat_number" do
    build(:country).save
    expect(build :billing_address).to be_valid
  end

  it {should validate_presence_of :company}
  it {should validate_presence_of :first_name}
  it {should validate_presence_of :surname}
  it {should validate_presence_of :email_address}
  it {should validate_presence_of :street}
  it {should validate_presence_of :postalcode}
  it {should validate_presence_of :city}
  it {should validate_presence_of :country}

  it {should belong_to :user}
  it {should validate_presence_of :user}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


# Instance Methods

  context "if_country_exists" do
    it "return error for non-existing country" do
      @billingaddress = build(:billing_address, country: "Wonderland")
      @billingaddress.if_country_exists
      expect(@billingaddress.errors.messages[:base]).to include("Unbekanntes Land")
    end

    it "return no error for existing country" do
      create(:country)

      @billingaddress = build(:billing_address)
      @billingaddress.if_country_exists
      expect(@billingaddress.errors.messages[:base]).to be_nil
    end
  end
end