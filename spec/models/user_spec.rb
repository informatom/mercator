require 'spec_helper'

describe User do
  it "is valid with a first_name, surname, email_address, last_login_at, gtc_confirmed_at,
      gtc_version_of, erp_account_nr, erp_contact_nr but without administrator" do
    expect(build :user).to be_valid
  end

  it {should validate_presence_of :surname}
  it {should validate_presence_of :email_address}

  it {should validate_uniqueness_of :email_address}

  it {should have_many :addresses}
  it {should have_many :billing_addresses}
  it {should have_many :orders}
  it {should have_many :offers}
  it {should have_many :comments}
  it {should have_many :conversations}

  it "is valid with a name, email_address and administrator" do
    expect(build :admin).to be_valid
  end

  it "is valid with a name, email_address and sales" do
    expect(build :sales).to be_valid
  end

  it "is valid with a name, email_address and sales manager" do
    expect(build :salesmanager).to be_valid
  end

  it "is versioned" do
    should respond_to :versions
  end

  it "has a photo attached" do
    should respond_to :photo
  end
end