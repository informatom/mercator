require 'spec_helper'

describe PropertyGroup do
  it "is valid with name_de, name_en, icecat_id and position" do
    expect(build(:property_group)).to be_valid
  end

  it {should validate_presence_of(:name_de)}

  it {should validate_presence_of(:position)}
  it {should validate_numericality_of(:position)}

  it {should have_many(:properties)}
  it {should have_many(:products)}
  it {should have_many(:values)}

  it "is versioned" do
    is_expected.to respond_to(:versions)
  end
end