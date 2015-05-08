require 'spec_helper'

describe Gtc do
  it "is valid with titel_de, titel_en, content_de, content_en, version_of" do
    expect(build(:gtc)).to be_valid
  end

  it {should validate_presence_of :title_de}
  it {should validate_presence_of :title_en}
  it {should validate_presence_of :content_de}
  it {should validate_presence_of :content_en}
  it {should validate_presence_of :version_of}

  it "is versioned" do
    should respond_to :versions
  end
end
