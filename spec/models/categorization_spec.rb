require 'spec_helper'

describe Categorization do
  it {should belong_to(:product)}
  it {should belong_to(:category)}

  it {should validate_presence_of(:product)}
  it {should validate_presence_of(:category_id)}
  it {should validate_uniqueness_of(:category_id)}

  it "acts as a list" do
  	should respond_to(:move_to_top)
  end

  it "is versioned" do
    should respond_to(:versions)
  end
end