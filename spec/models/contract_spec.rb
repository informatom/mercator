require 'spec_helper'

describe Contract do
  it "is valid with start_date, runtime" do
    expect(build(:contract)).to be_valid
  end

  it {should validate_presence_of(:startdate) }
  it {should validate_presence_of(:runtime) }

  it {should belong_to(:customer) }
  it {should validate_presence_of(:customer) }

  it {should belong_to(:consultant) }
  it {should validate_presence_of(:consultant) }

  it {should belong_to(:conversation) }

  it {should have_many(:contractitems) }

  it "is versioned" do
    should respond_to(:versions)
  end
end