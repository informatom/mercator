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
    should respond_to :versions
  end
end