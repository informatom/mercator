require 'spec_helper'

describe Order do
  it "is valid with billing_method, billing_gender, billing_title, billing_first_name," +
     "billing_surname, billing_company, billing_detail, billing_street, billing_postalcode, " +
     "billing_city, billing_country, billing_phone, shipping_method, shipping_gender, " +
     "shipping_first_name, shipping_surname, shipping_company, shipping_detail, shipping_street," +
     "shipping_postalcode, shipping_city, shipping_country, shipping_phone, store, gtc_confirmed_at," +
     "gtc_version_of, erp_customer_number, erp_billing_number, erp_order_number, discount_rel" do
    expect(build :order).to be_valid
  end

  it {should belong_to :user}
  it {should validate_presence_of :user}

  it {should have_many :lineitems}
  it {should belong_to :conversation}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  context "basket?" do
    it "returns true for basket" do
      @order = create(:order, state: "basket")
      expect(@order.basket?).to eql(true)
    end

    it "it returns false, if no basket" do
      @order = create(:order, state: "ordered")
      expect(@order.basket?).to eql(false)
    end
  end


  context "shippable?" do
    it "returns true if all lineitems are shippable" do
      @order = create(:order)
      @lineitem = create(:lineitem, order: @order)
      expect(@order.shippable?).to eql(true)
    end

    it "returns false if at least one lineitems is not shippable" do
      @order = create(:order)
      @product = create(:product, not_shippable: true)
      @lineitem = create(:lineitem, order: @order,
                                    product: @product)
      expect(@order.shippable?).to eql(false)
    end
  end


  context "accepted_offer?" do
    it "returns true for accepted_offer" do
      @order = create(:order, state: "accepted_offer")
      expect(@order.accepted_offer?).to eql(true)
    end

    it "it returns false, if no accepted_offer" do
      @order = create(:order, state: "ordered")
      expect(@order.accepted_offer?).to eql(false)
    end
  end

  context "order calculations" do
    before :each do
      @order = create(:order, discount_rel: 10)
      @product = create(:product)
      create(:lineitem, order: @order, value: 5, product: @product)
      create(:lineitem, order: @order, value: 7, product: @product)
    end

    context "sum" do
      it "returns sum of order" do
        expect(@order.sum).to eql(10.8)
      end
    end


    context "vat" do
      it "returns vat of order" do
        expect(@order.vat).to eql(2.16)
      end
    end


    context "sum_incl_vat" do
      it "returns sum including vat of order" do
        expect(@order.sum_incl_vat).to eql(12.96)
      end
    end


    context "vat_items" do
      it "returns hash of vat items" do
        create(:lineitem, order: @order, value: 7, product: @product, vat: 10)
        expect(@order.vat_items).to eql({BigDecimal.new("10") => BigDecimal.new("0.63"),
                                         BigDecimal.new("20") => BigDecimal.new("2.16")})
      end
    end

    context "name", focus: true do
      it "returns name for basket" do
        expect(@order.name).to include("Basket from")
      end

      it "returns name for accepted offer" do
        @order.state = "accepted_offer"
        expect(@order.name).to include("Order from")
      end
    end
  end

  # --- Class Methods --- #
end