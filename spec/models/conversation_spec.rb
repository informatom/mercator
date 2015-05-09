require 'spec_helper'

describe Conversation do
  it "is valid with name, customer, consultant" do
    expect(build :conversation).to be_valid
  end

  it {should validate_presence_of :name}

  it {should belong_to :customer}
  it {should validate_presence_of :customer}

  it {should belong_to :consultant}

  it {should have_many :downloads}
  it {should have_many :messages}
  it {should have_many :links}
  it {should have_many :offers}
  it {should have_many :baskets}
  it {should have_many :products}
  it {should have_many :suggestions}

  it "is versioned" do
    should respond_to :versions
  end
end