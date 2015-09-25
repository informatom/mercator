require 'spec_helper'

describe Consumableitem do
  it "is valid with contractitem, position, product_number, contract_type, product_line, description_de, " +
     "description_en, amount, theyield, wholesale_price1, wholesale_price2, wholesale_price3, " +
     "wholesale_price4, wholesale_price5, term, consumption1, consumption2," +
     "consumption3, consumption4, consumption5" do
    expect(build :consumableitem).to be_valid
  end

  it {should validate_presence_of :position}
  it {should validate_presence_of :amount}
  it {should validate_presence_of :theyield}
  it {should validate_presence_of :wholesale_price1}
  it {should validate_presence_of :wholesale_price2}
  it {should validate_presence_of :wholesale_price3}
  it {should validate_presence_of :wholesale_price4}
  it {should validate_presence_of :wholesale_price5}
  it {should validate_presence_of :consumption1}
  it {should validate_presence_of :consumption2}
  it {should validate_presence_of :consumption3}
  it {should validate_presence_of :consumption4}
  it {should validate_presence_of :consumption5}
  it {should validate_presence_of :consumption6}

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
      expect(@consumableitem.price).to eql 14
    end

    it "returns monthly_rate" do
      expect(@consumableitem.monthly_rate).to be_within(0.01).of 7.0
    end

    it "returns value" do
      expect(@consumableitem.value).to eql 14
    end

    it "returns new_rate" do
      expect(@consumableitem.new_rate(2)).to eql 7.0
      expect(@consumableitem.new_rate(3)).to be_within(0.01).of 4.667
      expect(@consumableitem.new_rate(4)).to be_within(0.01).of 5.833
      expect(@consumableitem.new_rate(5)).to be_within(0.01).of 7
      expect(@consumableitem.new_rate(6)).to be_within(0.01).of 8.166
    end

    it "returns balance" do
      expect(@consumableitem.balance(1)).to eql 0.0
      expect(@consumableitem.balance(2)).to be_within(0.01).of -28
      expect(@consumableitem.balance(3)).to be_within(0.01).of 14
      expect(@consumableitem.balance(4)).to be_within(0.01).of 14
      expect(@consumableitem.balance(5)).to be_within(0.01).of 14
    end

    it "returns consumption" do
      expect(@consumableitem.consumption(1)).to eql 3
      expect(@consumableitem.consumption(2)).to eql 4
      expect(@consumableitem.consumption(3)).to eql 5
      expect(@consumableitem.consumption(4)).to eql 6
      expect(@consumableitem.consumption(5)).to eql 7
    end
  end
end