require 'spec_helper'

describe Category do
  it "is valid with name_de, name_en, position" do
    expect(build(:category)).to be_valid
  end

  it {should validate_presence_of(:name_de)}
  it {should validate_numericality_of(:position)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it "is in a tree structure" do
    should respond_to(:parent)
    should respond_to(:children)
  end

  it "has a document attached" do
    should respond_to(:document)
  end
  it "has a photo attached" do
    should respond_to(:photo)
  end

  it {should have_many(:products)}
  it {should have_many(:categorizations)}
end