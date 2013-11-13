require 'spec_helper'
describe Property do
  it "is underspecified with name_de" do
    expect(build(:property, description_de: nil, value: nil, unit_de: nil)).not_to be_valid
  end
  it "is underspecified with name_de, value" do
    expect(build(:property, description_de: nil, unit_de: nil)).not_to be_valid
  end
  it "is underspecified with name_de, unit_de" do
    expect(build(:property, description_de: nil, value: nil)).not_to be_valid
  end
  it "is overspecified with name_de, name_en, description_de, value, unit_de" do
    expect(build(:property)).not_to be_valid
  end
  it "is valid with name_de, name_en, value, unit_de" do
    expect(build(:property, description_de: nil)).to be_valid
  end
  it "is valid with name_de, name_en, description_de, description_en" do
    expect(build(:property, value: nil, unit_de: nil)).to be_valid
  end

  it {should validate_presence_of(:name_de)}
  it {should belong_to(:product)}
  it {should validate_presence_of(:product)}
  it {should belong_to(:property_group)}
  it {should validate_uniqueness_of(:name_de)}

  it "is versioned" do
    should respond_to(:versions)
  end
end