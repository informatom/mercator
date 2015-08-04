require 'spec_helper'

describe Consumableitem do
  it "is valid with contractitem, position, product_number, contract_type, product_line, description_de, " +
     "description_en, amount, theyield, wholesale_price, term, consumption1, consumption2," +
     "consumption3, consumption4, consumption5, consumption6, balance6" do
    expect(build :consumableitem).to be_valid
  end

  it {should validate_presence_of :position}
  it {should validate_presence_of :amount}
  it {should validate_presence_of :theyield}
  it {should validate_presence_of :wholesale_price}
  it {should validate_presence_of :term}
  it {should validate_presence_of :consumption1}
  it {should validate_presence_of :consumption2}
  it {should validate_presence_of :consumption3}
  it {should validate_presence_of :consumption4}
  it {should validate_presence_of :consumption5}
  it {should validate_presence_of :consumption6}
  it {should validate_presence_of :balance6}

  it {should belong_to :contractitem}
  it {should validate_presence_of :contractitem}


  it "is versioned" do
    is_expected.to respond_to :versions
  end

 # --- Instance Methods --- #

  context "calculations" do
    before :each do
      @consumableitem = create(:consumableitem)
    end

    it "returns price" do
      expect(@consumableitem.price).to eql 13.75
    end

    it "returns monthly_rate" do
      expect(@consumableitem.monthly_rate).to be_within(0.01).of 6.875
    end

    it "returns value" do
      expect(@consumableitem.value).to eql 13.75
    end

    it "returns new_rate" do
      expect(@consumableitem.new_rate(2)).to eql 3.4375
      expect(@consumableitem.new_rate(3)).to eql 3.4375
      expect(@consumableitem.new_rate(4)).to be_within(0.01).of 4.5833
      expect(@consumableitem.new_rate(5)).to be_within(0.01).of 5.72917
      expect(@consumableitem.new_rate(6)).to eql 6.875
    end

    it "returns balance" do
      expect(@consumableitem.balance(1)).to eql -41.25
      expect(@consumableitem.balance(2)).to eql 0.0
      expect(@consumableitem.balance(3)).to be_within(0.01).of 13.75
      expect(@consumableitem.balance(4)).to be_within(0.01).of 13.75
      expect(@consumableitem.balance(5)).to be_within(0.01).of 13.75
    end

    it "returns consumption" do
      expect(@consumableitem.consumption(2)).to eql 3
      expect(@consumableitem.consumption(3)).to eql 4
      expect(@consumableitem.consumption(4)).to eql 5
      expect(@consumableitem.consumption(5)).to eql 6
      expect(@consumableitem.consumption(6)).to eql 7
    end
  end
end