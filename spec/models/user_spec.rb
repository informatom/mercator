require 'spec_helper'

describe User do
  it "is valid with a name, email_address but without administrator" do
    expect(build(:user)).to be_valid
  end

  it "is valid with a name, email_address and administrator" do
    expect(build(:admin)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:user, name: nil)).to have(1).errors_on(:name)
  end
end
