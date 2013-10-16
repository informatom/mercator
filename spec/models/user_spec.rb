require 'spec_helper'

describe User do
  it "is valid with a name, email_address and administrator" do
    user = User.new( name: "Stefan", email_address: "stefan.haslinger@mittenin.at", administrator: true )
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    expect(User.new(name: nil)).to have(1).errors_on(:name)
  end
end
