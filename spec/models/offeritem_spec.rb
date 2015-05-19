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

  context "update_from_product" do
    before :each do
      @offeritem = create(:offeritem_two)
      @product = create(:product_with_inventory_and_two_prices)
    end

    context "update with existing product" do
      before :each do
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
        expect(@offeritem.vat).to eql 10
      end

      it "runs an new pricing" do
        expect(@offeritem).to receive(:new_pricing)
        @offeritem.update_from_product(product_number: "product_with_inventory_and_two_prices",
                               amount: 67,
                               discount_abs: 10)
      end
    end

    context "update with non existing product" do
      before :each do
        @offeritem.update_from_product(product_number: "non_existing",
                                       amount: 67,
                                       discount_abs: 10)
      end

      it "nils product_id" do
        expect(@offeritem.product_id).to eql nil
      end

      it "nils delivery_time" do
        expect(@offeritem.delivery_time).to eql nil
      end
    end
  end


  context "vat_value" do
    it "returns vat_value without discount" do
      @offeritem =  create(:offeritem)
      expect(@offeritem.vat_value).to eql 1036.98
    end

    it "returns vat_value with discount" do
      @offeritem =  create(:offeritem)
      expect(@offeritem.vat_value(discount_rel: 10)).to eql 933.282
    end
  end


  context "new_pricing" do
    before :each do
      @product = create(:product_with_inventory_and_two_prices)
      @offeritem = create(:offeritem, amount: 1,
                                      discount_abs: 0,
                                      product: @product)
    end

    it "sets a product price" do
      @offeritem.new_pricing
      expect(@offeritem.product_price).to eql(42)
    end

    it "calculates a value" do
      @offeritem.new_pricing
      expect(@offeritem.value).to eql(42)
    end

    it "takes amount into consideration for value" do
      @offeritem.amount = 10
      @offeritem.new_pricing
      expect(@offeritem.value).to eql(380)
    end

    it "takes discount into consideration for value" do
      @offeritem.discount_abs = 10
      @offeritem.new_pricing
      expect(@offeritem.value).to eql(32)
    end
  end
end