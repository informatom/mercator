require 'spec_helper'

describe PageElement do
  it "is valid with used_as, page, usage" do
    expect(build(:page_element)).to be_valid
  end

  it {should validate_presence_of(:used_as)}
  it {should validate_uniqueness_of(:used_as)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it {should belong_to(:page)}
  it {should validate_presence_of(:page)}
  it {should belong_to(:usage)}
  it {should validate_presence_of(:usage)}

end