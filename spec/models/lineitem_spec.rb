require 'spec_helper'

describe Lineitem do
  it "is valid with position, product_number, product, description_de,
     description_en, amount, unit, product_price, vat and value" do
    expect(build(:lineitem)).to be_valid
  end

  it {should validate_presence_of(:product_number)}
  it {should validate_uniqueness_of(:product_number)}

  it {should validate_presence_of(:position)}
  it {should validate_numericality_of(:position)}

  it {should validate_presence_of(:description_de)}
  it {should validate_presence_of(:amount)}
  it {should validate_numericality_of(:amount)}
  it {should validate_presence_of(:unit)}

  it {should validate_presence_of(:product_price)}
  it {should validate_numericality_of(:product_price)}

  it {should validate_presence_of(:vat)}
  it {should validate_numericality_of(:vat)}

  it {should validate_presence_of(:value)}
  it {should validate_numericality_of(:value)}

  it {should belong_to(:order)}
  it {should validate_presence_of(:order)}

  it {should belong_to(:user)}
  it {should validate_presence_of(:user)}

  it {should belong_to(:product)}


  it "acts as a list" do
    should respond_to(:move_to_top)
  end

  it "is versioned" do
    should respond_to(:versions)
  end
end