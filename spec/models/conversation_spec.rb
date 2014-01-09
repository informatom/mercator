require 'spec_helper'

describe Conversation do
  it "is valid with name, customer, consultant" do
    expect(build(:conversation)).to be_valid
  end

  it {should validate_presence_of(:name)}

  it {should belong_to(:customer)}
  it {should validate_presence_of(:customer)}

  it {should belong_to(:consultant)}
  it {should validate_presence_of(:consultant)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it {should have_many(:downloads)}
  it {should have_many(:messages)}
end