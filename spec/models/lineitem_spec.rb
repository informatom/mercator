require 'spec_helper'

describe Lineitem do
  it "is valid with position, product_number, description_de,
     description_en, amount, product_price, vat and value" do
    expect(build(:lineitem)).to be_valid
  end

  it {should validate_presence_of(:position)}
  it {should validate_presence_of(:product_number)}
  it {should validate_presence_of(:description_de)}
  it {should validate_presence_of(:amount)}
  it {should validate_presence_of(:product_price)}
  it {should validate_presence_of(:vat)}
  it {should validate_presence_of(:value)}
  pending "it {should validate_uniqueness_of(:position)}"
  pending "it {should validate_uniqueness_of(:product_number)}"

  it "is versioned" do
    should respond_to(:versions)
  end
end