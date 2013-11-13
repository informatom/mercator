require 'spec_helper'

describe Product do
  it "is valid with name_de, name_en, number, description_de, description_en" do
    expect(build(:product)).to be_valid
  end

  it {should validate_presence_of(:name_de)}
  it {should validate_presence_of(:number)}
  it {should validate_presence_of(:description_de)}
  it {should validate_uniqueness_of(:number)}

  it {should have_many(:property_groups)}
  it {should have_many(:properties)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it "has a document attached" do
    should respond_to(:document)
  end
  it "has a photo attached" do
    should respond_to(:photo)
  end
end