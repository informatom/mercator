require 'spec_helper'

describe Suggestion do
  it "is valid with product, conversation" do
    expect(build :suggestion).to be_valid
  end

  it {should belong_to :product}
  it {should validate_presence_of :product}

  it {should belong_to :conversation}
  it {should validate_presence_of :conversation}

  it "is versioned" do
    should respond_to :versions
  end
end