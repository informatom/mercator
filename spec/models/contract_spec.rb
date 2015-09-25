require 'spec_helper'

describe Contract do
  it "is valid with start_date, contractnumber, customer, customer_account" do
    expect(build :contract).to be_valid
  end

  it {should have_many :contractitems}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  it "returns enddate" do
    @contract = create(:contract)
    expect(@contract.enddate).to eql Date.new(2019, 03, 05)
  end
end