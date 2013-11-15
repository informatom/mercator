require 'spec_helper'

describe Inventory do
  it "is valid with name_de, name_en, number, amount, unit,
                    comment_de, comment_en, weight, charge, storage" do
    expect(build(:inventory)).to be_valid
  end

  it {should validate_presence_of(:name_de)}
  it {should validate_presence_of(:number)}
  it {should validate_presence_of(:amount)}
  it {should validate_presence_of(:unit)}
  it {should validate_uniqueness_of(:number)}

  it {should belong_to(:product)}
  it {should validate_presence_of(:product)}
  it {should have_many(:prices)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it "has a photo attached" do
    should respond_to(:photo)
  end
end