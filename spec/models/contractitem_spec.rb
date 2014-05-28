require 'spec_helper'

describe Contractitem do
  it "is valid with contract, user, position, product, product_number,
      description_de, description_en, amount, unit, product_price,
      vat, discount_abs, toner, value" do
    expect(build(:contractitem)).to be_valid
  end

  it {should validate_presence_of(:position)}

  it {should validate_presence_of(:description_de)}
  it {should validate_numericality_of(:amount)}

  it {should validate_numericality_of(:product_price)}
  it {should validate_numericality_of(:vat)}
  it {should validate_numericality_of(:value)}

  it {should belong_to(:contract)}
  it {should validate_presence_of(:contract)}

  it {should belong_to(:user)}

  it {should belong_to(:product)}
  it {should belong_to(:toner)}

  it "acts as a list" do
    should respond_to(:move_to_top)
  end

  it "is versioned" do
    should respond_to(:versions)
  end
end
