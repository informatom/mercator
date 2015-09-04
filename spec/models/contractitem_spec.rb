require 'spec_helper'

describe Contractitem do
  it "is valid with contract, user, position, product, product_number,
      description_de, description_en, amount, unit, product_price,
      vat, discount_abs, toner, value, volume" do
    expect(build :contractitem).to be_valid
  end

  it {should validate_presence_of :position}

  it {should validate_numericality_of :amount}

  it {should validate_numericality_of :vat}

  it {should validate_presence_of :volume}
  it {should validate_presence_of :vat}
  it {should validate_presence_of :term}
  it {should validate_presence_of :startdate}
  it {should validate_presence_of :marge}

  it {should belong_to :contract}
  it {should validate_presence_of :contract}

  it {should belong_to :product}

  it {should have_many :consumableitems}

  it "acts as a list" do
    is_expected.to respond_to :move_to_top
  end

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  context "calculations" do
    before :each do
      @contractitem = create(:contractitem)
      @consumableitem = create(:consumableitem, contractitem_id: @contractitem.id)
      @contractitem.reload
    end


    it "returns price" do
      expect(@contractitem.price).to eql 14
    end

    it "returns enddate" do
      expect(@contractitem.enddate).to eql Date.new(2016, 8, 2)
    end

    it "returns monthly_rate" do
      expect(@contractitem.monthly_rate).to be_within(0.01).of 1.1666
    end

    it "returns value" do
      expect(@contractitem.value).to be_within(0.01).of 49.0
    end

    it "returns value_incl_vat" do
      expect(@contractitem.value_incl_vat).to be_within(0.01).of 4909.8
    end

    it "returns new_rate" do
      expect(@contractitem.new_rate(2)).to eql 7.0
      expect(@contractitem.new_rate(3)).to be_within(0.01).of 4.6666
      expect(@contractitem.new_rate(4)).to be_within(0.01).of 5.8333
      expect(@contractitem.new_rate(5)).to be_within(0.01).of 7.0
    end

    it "returns balance" do
      expect(@contractitem.balance(1)).to eql 0.0
      expect(@contractitem.balance(2)).to be_within(0.01).of -28.0
      expect(@contractitem.balance(3)).to be_within(0.01).of 14
      expect(@contractitem.balance(4)).to be_within(0.01).of 14
      expect(@contractitem.balance(5)).to be_within(0.01).of 14
    end

    it "returns months_without_rates" do
      expect(@contractitem.months_without_rates(1)).to eql 0
      expect(@contractitem.months_without_rates(2)).to eql 5
      expect(@contractitem.months_without_rates(3)).to eql 0
      expect(@contractitem.months_without_rates(4)).to eql 0
    end

    it "returns next_month" do
      expect(@contractitem.next_month(1)).to eql 7.0
      expect(@contractitem.next_month(2)).to be_within(0.01).of 4.67
      expect(@contractitem.next_month(3)).to be_within(0.01).of 5.83
      expect(@contractitem.next_month(4)).to be_within(0.01).of 7.0
    end
  end
end