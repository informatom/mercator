require 'spec_helper'

describe Contract do
  it "is valid with start_date, runtime" do
    expect(build(:contract)).to be_valid
  end

  it {should validate_presence_of :startdate}
  it {should validate_presence_of :runtime}

  it "is versioned" do
    should respond_to(:versions)
  end
end