require 'spec_helper'

describe Gtc do
  it "is valid with titel_de, titel_en, content_de, content_en, version_of" do
    expect(build :gtc).to be_valid
  end

  it {should validate_presence_of :title_de}
  it {should validate_presence_of :title_en}
  it {should validate_presence_of :content_de}
  it {should validate_presence_of :content_en}
  it {should validate_presence_of :version_of}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

# ---  CLass Methods  --- #

  context "current" do
    it "returns the latest date" do
      create(:older_gtc)
      create(:newer_gtc)
      create(:gtc)
      expect(Gtc.current).to eq(Date.new(2014, 1, 23))
    end
  end
end