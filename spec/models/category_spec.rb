require 'spec_helper'

describe Category do
  it "is valid with name_de, name_en, description_de, description_en, long_description_de," +
     "long_description_en, ancestry, position, legacy_id, filters, filtermin, filtermax," +
     "erp_identifier, usage, squeel_condition, photo, document" do
    expect(build(:category)).to be_valid
  end

  it {should validate_presence_of(:name_de)}
  it {should validate_presence_of(:name_en)}

  it {should validate_numericality_of(:position).only_integer}
  it {should validate_presence_of(:position)}

  it {should have_many(:products)}
  it {should have_many(:categorizations)}

  it {should have_many(:values)}
  it {should have_many(:properties)}

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

  it "is versioned" do
    should respond_to(:versions)
  end
end