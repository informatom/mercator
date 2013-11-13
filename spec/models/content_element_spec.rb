require 'spec_helper'

describe ContentElement do
  it "is valid with content_de, content_en, name_de, name_en, markup" do
    expect(build(:address)).to be_valid
  end

  it {should validate_presence_of :name_de}
  it {should validate_uniqueness_of :name_de}
  it {should validate_presence_of :content_de}

  it "is versioned" do
    should respond_to(:versions)
  end
end