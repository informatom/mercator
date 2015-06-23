require 'spec_helper'

describe MercatorMesonic::Price do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Price.table_name).to eql "T043"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Price.primary_key).to eql "MESOKEY"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Price.unscoped.mesocomp.limit(100).pluck(:MESOKEY))
                            .to match_array MercatorMesonic::Price.unscoped.where(mesocomp: @mesocomp).limit(100).pluck(:MESOKEY)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Price.unscoped.mesoyear.pluck(:MESOKEY))
                            .to match_array MercatorMesonic::Price.unscoped.where(mesoyear: @mesoyear).pluck(:MESOKEY)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Price.pluck(:MESOKEY))
                            .to match_array MercatorMesonic::Price.unscoped.mesocomp.mesoyear.where(c002: 3).pluck(:MESOKEY)
    end

    it "has a scope by_kontonummer" do
      expect(MercatorMesonic::Price.by_customer("661016").*.c003.uniq).to match_array ["661016"]
    end

    it "has a scope by date" do
      expect(MercatorMesonic::Price.for_date(Date.today).count < MercatorMesonic::Price.all.count).to eql true
    end

    it "has a scope by_group_through_customer" do
      expect(MercatorMesonic::Price.by_group_through_customer("011903").count > 0).to eql true
    end

    it "has a scope group" do
      expect(MercatorMesonic::Price.group("011903").count > 0).to eql true
    end

    it "has a scope by_group" do
      expect(MercatorMesonic::Price.by_group("160").count > 0).to eql true
    end

    it "has a scope regular" do
      expect(MercatorMesonic::Price.regular.count > 0).to eql true
    end
  end


  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::Price.new().readonly?).to eql true
  end


  it "returns c013 fo to_s" do
    @price = MercatorMesonic::Price.find_by(MESOKEY: 1395561)
    expect(@price.to_s).to eql 150.0
  end

  it "returns c013 when called price" do
    @price = MercatorMesonic::Price.find_by(MESOKEY: 1395561)
    expect(@price.price).to eql 150.0
  end
end