require 'spec_helper'

describe Contract do
  it "is valid with start_date, term" do
    expect(build :contract).to be_valid
  end

  it {should belong_to :customer}
  it {should belong_to :consultant}

  it {should belong_to :conversation}

  it {should have_many :contractitems}

  it "is versioned" do
    is_expected.to respond_to :versions
  end
end