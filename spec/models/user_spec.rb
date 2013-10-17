require 'spec_helper'

describe User do
  it "is valid with a name, email_address but without administrator" do
    user = FactoryGirl.build(:user)
    expect(user).to be_valid
  end

  it "is valid with a name, email_address and administrator" do
    admin = FactoryGirl.build(:admin)
    expect(admin).to be_valid
  end

  it "is invalid without a name" do
    expect(User.new(name: nil)).to have(1).errors_on(:name)
  end
end
