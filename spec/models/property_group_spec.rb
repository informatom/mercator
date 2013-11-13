require 'spec_helper'

describe PropertyGroup do
  it "is valid with name_de, name_en and position" do
    expect(build(:property_group)).to be_valid
  end

  it {should validate_presence_of(:name_de)}
  it {should validate_presence_of(:position)}
  it {should belong_to(:product)}
  it {should validate_presence_of(:product_id)}
  it {should have_many(:properties)}

  it "is versioned" do
    should respond_to(:versions)
  end
end