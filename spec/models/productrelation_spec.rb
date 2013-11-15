require 'spec_helper'

describe Productrelation do
  it {should belong_to(:product)}
  it {should belong_to(:related_product)}

  it {should validate_presence_of(:related_product_id)}
  it {should validate_presence_of(:product)}
  it {should validate_uniqueness_of(:related_product_id)}

  it "is versioned" do
    should respond_to(:versions)
  end
end