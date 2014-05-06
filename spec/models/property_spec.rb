require 'spec_helper'
describe Property do
  it "is valid with name_de, name_en, datatype, position, icecat_id" do
    expect(build(:property)).to be_valid
  end

  it {should validate_presence_of(:name_de)}

  it {should validate_presence_of(:position)}
  it {should validate_numericality_of(:position)}

  it {should validate_presence_of(:datatype)}
  it { should ensure_inclusion_of(:datatype).in_array(%w(textual numeric flag)) }

  it {should have_many(:property_groups)}
  it {should have_many(:products)}
  it {should have_many(:values)}

  it "is versioned" do
    should respond_to(:versions)
  end
end