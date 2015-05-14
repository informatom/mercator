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

  #--- Class Methods --- #

  context "dedup" do
    before :each do
      @product = create(:product)
      @property_group = create(:property_group)
      @property = create(:property)
      @value = create(:textual_value, property: @property,
                                      property_group: @property_group,
                                      product: @product)
      @another_property_group = create(:property_group)
      @another_value = create(:textual_value, property: @property,
                                              property_group: @another_property_group,
                                              product: @product)
    end

    it "deletes duplicate properties after values have been removed" do
      expect{PropertyGroup.dedup}.to change{PropertyGroup.all.count}.by(-1)
    end

    it "doesn't delete values" do
      expect{Property.dedup}.not_to change{Value.all.count}
    end
  end
end