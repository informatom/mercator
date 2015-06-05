require 'spec_helper'

describe Property do
  it "is valid with name_de, name_en, datatype, position, icecat_id" do
    expect(build :property).to be_valid
  end

  it {should validate_presence_of :name_de}

  it {should validate_presence_of :position}
# conflicts with acts_as_list
# it {should validate_numericality_of :position}

  it {should validate_presence_of :datatype}
  it {should validate_inclusion_of(:datatype).in_array(%w(textual numeric flag)) }

  it {should have_many :property_groups}
  it {should have_many :products}
  it {should have_many :values}

  it "is versioned" do
    is_expected.to respond_to :versions
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
      @another_property = create(:property)
      @another_value = create(:textual_value, property: @another_property,
                                              property_group: @property_group,
                                              product: @product)
    end

    it "deletes duplicate properties after values have been removed" do
      expect{Property.dedup}.to change{Property.all.count}.by(-1)
    end

    it "doesn't delete values" do
      expect{Property.dedup}.not_to change{Value.all.count}
    end
  end
end