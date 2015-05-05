require 'spec_helper'

describe Product do
  it "is valid with title_de, title_en, number, description_de, description_en,
      long_description_de, long_description_en, warranty_de, warranty_en,
      document, photo" do
    expect(build(:product)).to be_valid
  end

  it {should validate_presence_of(:title_de)}
  it {should validate_presence_of(:number)}
  it {should validate_presence_of(:description_de)}
  it {should validate_uniqueness_of(:number)}

  it {should have_many(:property_groups)}
  it {should have_many(:properties)}
  it {should have_many(:values)}

  it {should have_many(:categories)}
  it {should have_many(:categorizations)}

  it {should have_many(:related_products)}
  it {should have_many(:productrelations)}

  it {should have_many(:recommended_products)}
  it {should have_many(:recommendations)}

  it {should have_many(:supplies)}
  it {should have_many(:supplyrelations)}

  it {should have_many(:features)}

  it {should have_many(:inventories)}

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