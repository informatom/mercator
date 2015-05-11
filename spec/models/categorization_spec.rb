require 'spec_helper'

describe Categorization do
  it "is valid with position, product, category" do
    expect(build :categorization).to be_valid
  end

  it {should validate_presence_of :position}

  it {should belong_to :product}
  it {should belong_to :category}

  it {should validate_presence_of :product}
  it {should validate_presence_of :category_id}
  it {should validate_uniqueness_of :category_id}

  it "acts as a list" do
  	is_expected.to respond_to :move_to_top
  end

  it "is versioned" do
    is_expected.to respond_to :versions
  end


# ---  CLass Methods  --- #

  context "complement" do
    it "creates categorization if there isn't one" do
      expect{Categorization.complement(product: create(:product),
                                       category: create(:category))}.to change{Categorization.count}.by(1)
    end

    it "doesn't create categorization if there is already" do
      @categorization = create(:categorization)
      expect{Categorization.complement(product: @categorization.product,
                                       category: @categorization.category)}.to_not change{Categorization.count}
    end
  end
end