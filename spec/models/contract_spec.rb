require 'spec_helper'

describe Contract do
  it "is valid with start_date, runtime" do
    expect(build :contract).to be_valid
  end

  it {should belong_to :customer}
  it {should belong_to :consultant}

  it {should belong_to :conversation}

  it {should have_many :contractitems}

  it "is versioned" do
    should respond_to :versions
  end
end