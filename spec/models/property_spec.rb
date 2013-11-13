require 'spec_helper'

describe Property do
  it "is valid with name_de, name_en, description_de, description_en, value, unit_de, unit_en" do
    expect(build(:property)).to be_valid
  end

  it {should validate_presence_of(:name_de)}
  it {should belong_to(:product)}
  it {should validate_presence_of(:product_id)}
  it {should belong_to(:property_group)}
  it {should validate_uniqueness_of(:name_de)}

  it "is versioned" do
    should respond_to(:versions)
  end
end