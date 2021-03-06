require 'spec_helper'

describe PostCategory do
  it "is valid with name_de, name_en, ancestry" do
    expect(build :post_category).to be_valid
  end

  it {should validate_presence_of :name_de}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "is in a tree structure" do
    is_expected.to respond_to :parent
    is_expected.to respond_to :children
  end

# ---  Instance Methods  --- #

  context "position" do
    it "returns 0" do
      expect(build(:post_category).position).to eq(0)
    end
  end
end