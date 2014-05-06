require 'spec_helper'

describe Recommendation do
  it "is valid with reason_de, reason_en, product, recommended_product" do
      expect(build(:recommendation)).to be_valid
  end

  it {should validate_presence_of(:reason_de)}

  it {should belong_to(:product)}
  it {should validate_presence_of(:product)}

  it {should belong_to(:recommended_product)}
  it {should validate_presence_of(:recommended_product_id)}
  it {should validate_uniqueness_of(:recommended_product_id)}

  it "is versioned" do
    should respond_to(:versions)
  end
end
