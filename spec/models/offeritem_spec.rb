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


  # --- Instance Methods --- #

  context "update_from_product", focus: true do
    before :each do
      @offeritem = create(:offeritem_two)
      @product = create(:product_with_inventory_and_two_prices)
      @offeritem.update_from_product(product_number: "product_with_inventory_and_two_prices",
                                     amount: 67,
                                     discount_abs: 10)
    end

    it "updates product_id" do
      expect(@offeritem.product_id).to eql @product.id
    end

    it "updates description_de" do
      expect(@offeritem.description_de).to eql @product.title_de
    end

    it "updates description_en" do
      expect(@offeritem.description_en).to eql @product.title_en
    end

    it "updates delivery_time" do
      expect(@offeritem.delivery_time).to eql @product.delivery_time
    end

    it "updates unit" do
      expect(@offeritem.unit).to eql "Stk."
    end

    it "updates vat" do
      expect(@offeritem.vat).to eql 18
    end
  end
end