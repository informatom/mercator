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

# Instance methods

  context "name" do
    it "returns a nicely formatted product name and number" do
      expect(build(:suggestion).name).eql? "(123):Artikel Eins Zwei Drei"
    end
  end
end