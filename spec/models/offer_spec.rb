require 'spec_helper'

describe Offer do
  it "is valid with billing_company, billing_gender, billing_title, billing_first_name, " +
     "billing_surname, billing_detail, billing_street, billing_postalcode, billing_city," +
     "billing_country, billing_phone, shipping_company, shipping_gender, shipping_title," +
     "shipping_first_name, shipping_surname, shipping_detail, shipping_street, shipping_postalcode," +
     "shipping_city, shipping_country, shipping_phone, valid_until, complete, discount_rel" do
    expect(build :offer).to be_valid
  end

  it {should validate_presence_of :valid_until}

  it {should belong_to :user}
  it {should validate_presence_of :user}

  it {should belong_to :consultant}
  it {should validate_presence_of :consultant}

  it {should have_many :offeritems}
  it {should belong_to :conversation}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  context "name" do
    it "displays the name" do
      @offer = create(:offer)
      expect(@offer.name).to include "Offer 1 from"
    end
  end


  context "sum" do
    it "returns the sum minus discount" do
      @offer = create(:offer, discount_rel: 10)
      @product = create(:product)
      @offeritem = create(:offeritem, value: 7,
                                      offer: @offer,
                                      product: @product)
      @offeritem = create(:offeritem, value: 11,
                                      offer: @offer,
                                      product: @product)
      expect(@offer.sum).to eql(16.2)
    end
  end


  context "sum_before_discount", focus: true do
    it "returns the sum" do
      @offer = create(:offer)
      @product = create(:product)
      @offeritem = create(:offeritem, value: 7,
                                      offer: @offer,
                                      product: @product)
      @offeritem = create(:offeritem, value: 11,
                                      offer: @offer,
                                      product: @product)
      expect(@offer.sum_before_discount).to eql(18)
    end
  end


  context "discount" do
    it "returns the sum" do
      @offer = create(:offer, discount_rel: 10)
      @product = create(:product)
      @offeritem = create(:offeritem, value: 7,
                                      offer: @offer,
                                      product: @product)
      @offeritem = create(:offeritem, value: 11,
                                      offer: @offer,
                                      product: @product)
      expect(@offer.discount).to eql(1.8)
    end

    it "gives 0 if no discount_rel" do
      @offer = create(:offer)
      expect(@offer.discount).to eql(0)
    end
  end


  context "sum_incl_vat" do
    it "returns the sum incl vat" do
      @offer = create(:offer, discount_rel: 10)
      @product = create(:product)
      @offeritem = create(:offeritem, value: 7,
                                      offer: @offer,
                                      product: @product)
      @offeritem = create(:offeritem, value: 11,
                                      offer: @offer,
                                      product: @product,
                                      vat: 10)
      expect(@offer.sum_incl_vat).to eql(18.45)
    end
  end


  context "vat_items" do
    it "returns the vat_items" do
      @offer = create(:offer, discount_rel: 10)
      @product = create(:product)
      @offeritem = create(:offeritem, value: 7,
                                      offer: @offer,
                                      product: @product)
      @offeritem = create(:offeritem, value: 11,
                                      offer: @offer,
                                      product: @product,
                                      vat: 10)
      expect(@offer.vat_items).to eql({BigDecimal.new("10") => BigDecimal.new("0.99"),
                                       BigDecimal.new("20") => BigDecimal.new("1.26")})
    end
  end
end