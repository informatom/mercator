require 'spec_helper'

describe Page do
  it "is valid with name_de, name_en" do
    expect(build(:page)).to be_valid
  end

  it {should validate_presence_of(:title_de)}

  it "is versioned" do
    should respond_to(:versions)
  end
end