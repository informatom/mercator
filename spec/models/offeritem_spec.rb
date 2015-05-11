require 'spec_helper'

describe Offeritem do
  it "is valid with position, product_number, product, description_de,
     description_en, amount, unit, product_price, vat and value" do
    expect(build :offer).to be_valid
  end

  it {should validate_presence_of :position}
  it {should validate_presence_of :description_de}

  it {should validate_numericality_of :amount}
  it {should validate_numericality_of :product_price}
  it {should validate_numericality_of :vat}
  it {should validate_numericality_of :value}

  it {should belong_to :offer}
  it {should validate_presence_of :offer}

  it {should belong_to :user}
  it {should belong_to :product}

  it "acts as a list" do
    is_expected.to respond_to :move_to_top
  end

  it "is versioned" do
    is_expected.to respond_to :versions
  end
end