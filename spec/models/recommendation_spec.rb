require 'spec_helper'

describe Recommendation do
  it {should belong_to(:product)}
  it {should belong_to(:recommended_product)}

  it {should validate_presence_of(:reason_de)}
  it {should validate_presence_of(:recommended_product_id)}
  it {should validate_presence_of(:product)}
  it {should validate_uniqueness_of(:recommended_product_id)}

  it "is versioned" do
    should respond_to(:versions)
  end
end
