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
    is_expected.to respond_to :versions
  end

# ---Instance Methods  --- #

  context "name" do
    it "returns a nicely formatted product name and number" do
      expect(build(:suggestion).name).to eql("(123) Article One Two Three")
    end
  end
end