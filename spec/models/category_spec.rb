require 'spec_helper'

describe Category do
  it "is valid with name_de, name_en, position" do
    expect(build(:category)).to be_valid
  end

  it {should validate_presence_of(:name_de)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it "is in a tree structure" do
    should respond_to(:parent)
    should respond_to(:children)
  end
end