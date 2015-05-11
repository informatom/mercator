require 'spec_helper'

describe Country do
  it "is valid with name_de, name_en, code" do
    expect(build :country).to be_valid
  end

  it {should validate_presence_of :name_de}
  it {should validate_uniqueness_of :name_de}
  it {should validate_presence_of :name_en}
  it {should validate_uniqueness_of :name_en}
  it {should validate_presence_of :code}
  it {should validate_uniqueness_of :code}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

# ---CLass Methods  --- #

  context "find_by_name" do
    it "can be found by name" do
      expect(Country).to respond_to(:find_by_name)
    end
  end
end