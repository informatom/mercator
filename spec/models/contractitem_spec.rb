require 'spec_helper'

describe Contractitem do
  it "is valid with contract, user, position, product, product_number, product_title, amount, unit, product_price,
      vat, toner, value, volume, monitoring_rate, startdate, volume_bw, volume_color, marge" do
    expect(build :contractitem).to be_valid
  end

  it {should validate_presence_of :position}

  it {should validate_numericality_of :amount}

  it {should validate_numericality_of :vat}

  it {should validate_presence_of :volume}
  it {should validate_presence_of :vat}
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
      expect(@contractitem.price(1)).to eql 14
      expect(@contractitem.price(2)).to eql 14
      expect(@contractitem.price(3)).to eql 14
      expect(@contractitem.price(4)).to eql 14
      expect(@contractitem.price(5)).to eql 14
    end

    it "returns monthly_rate" do
      expect(@contractitem.monthly_rate(1)).to be_within(0.01).of 0
      expect(@contractitem.monthly_rate(2)).to be_within(0.01).of 2.0
      expect(@contractitem.monthly_rate(3)).to be_within(0.01).of 8.0
      expect(@contractitem.monthly_rate(4)).to be_within(0.01).of 5.8333
      expect(@contractitem.monthly_rate(5)).to be_within(0.01).of 7.0
    end

    it "returns value" do
      expect(@contractitem.value(1)).to be_within(0.01).of 0
      expect(@contractitem.value(2)).to be_within(0.01).of 84.0
      expect(@contractitem.value(3)).to be_within(0.01).of 336.0
      expect(@contractitem.value(4)).to be_within(0.01).of 245.0
      expect(@contractitem.value(5)).to be_within(0.01).of 294.0
    end

    it "returns value_incl_vat" do
      expect(@contractitem.value_incl_vat(1)).to be_within(0.01).of 0.0
      expect(@contractitem.value_incl_vat(2)).to be_within(0.01).of 8416.8
      expect(@contractitem.value_incl_vat(3)).to be_within(0.01).of 33667.2
      expect(@contractitem.value_incl_vat(4)).to be_within(0.01).of 24549.0
      expect(@contractitem.value_incl_vat(5)).to be_within(0.01).of 29458.8
    end

    it "returns actual_rate_array" do
      expect(@contractitem.actual_rate_array).to eql [ nil,
        {:title=>"März", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 6,00", :year5=>"EUR 13,00"},
        {:title=>"April", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 6,00", :year5=>"EUR 13,00"},
        {:title=>"Mai", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 6,00", :year5=>"EUR 13,00"},
        {:title=>"Juni", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 6,00", :year5=>"EUR 13,00"},
        {:title=>"Juli", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 9,17", :year5=>"EUR 13,00"},
        {:title=>"August", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 11,83", :year5=>"EUR 13,00"},
        {:title=>"September", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 11,83", :year5=>"EUR 13,00"},
        {:title=>"Oktober", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 11,83", :year5=>"EUR 13,00"},
        {:title=>"November", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 11,83", :year5=>"EUR 13,00"},
        {:title=>"Dezember", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 11,83", :year5=>"EUR 13,00"},
        {:title=>"Januar", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 11,83", :year5=>"EUR 13,00"},
        {:title=>"Februar", :year1=>"EUR 6,00", :year2=>"EUR 8,00", :year3=>"EUR 14,00", :year4=>"EUR 11,83", :year5=>"EUR 13,00"} ]
    end

    it "returns balance" do
      expect(@contractitem.balance(1)).to eql 0
      expect(@contractitem.balance(2)).to be_within(0.01).of 42.0
      expect(@contractitem.balance(3)).to be_within(0.01).of -26.0
      expect(@contractitem.balance(4)).to be_within(0.01).of 14
      expect(@contractitem.balance(5)).to be_within(0.01).of 14
    end

    it "returns months_without_rates" do
      expect(@contractitem.months_without_rates(1)).to eql 0
      expect(@contractitem.months_without_rates(2)).to eql 0
      expect(@contractitem.months_without_rates(3)).to eql 4
      expect(@contractitem.months_without_rates(4)).to eql 0
    end

    it "returns next_month" do
      expect(@contractitem.next_month(1)).to eql 2.0
      expect(@contractitem.next_month(2)).to be_within(0.01).of 8.0
      expect(@contractitem.next_month(3)).to be_within(0.01).of 3.1666
      expect(@contractitem.next_month(4)).to be_within(0.01).of 7.0
    end
  end
end