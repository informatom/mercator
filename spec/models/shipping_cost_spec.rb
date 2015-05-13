require 'spec_helper'

describe ShippingCost do
  it "is valid with shipping_method, country, value, vat" do
    expect(build :shipping_cost).to be_valid
  end

  it {should validate_presence_of :value}
  it {should validate_presence_of :vat}
  it {should validate_presence_of :shipping_method}

  it {should validate_numericality_of :value}
  it {should validate_numericality_of :vat}

  it {should belong_to :country}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  #--- Class Methods --- #

  context "determine" do
    before :each do
      @order = build(:order)
      @country_unspecific_shipping_cost = create(:country_unspecific_shipping_cost)
    end

    it "determines country unspecific costs" do
      create(:country)
      expect(ShippingCost.determine(order: @order,
                                    shipping_method: "parcel_service_shipment")).to eql @country_unspecific_shipping_cost
    end

    it "determines country specific costs" do
      @country_specific_shipping_cost = create(:shipping_cost)
      expect(ShippingCost.determine(order: @order,
                                    shipping_method: "parcel_service_shipment")).to eql @country_specific_shipping_cost
    end
  end
end
