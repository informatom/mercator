require 'spec_helper'

describe MercatorMesonic::Price do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Price.table_name).to eql "MESOKEY"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Price.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Price.unscoped.mesocomp.pluck(:mesoprim))
                            .to match_array MercatorMesonic::Price.unscoped.where(mesocomp: @mesocomp).pluck(:mesoprim)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Price.unscoped.mesoyear.pluck(:mesoprim))
                            .to match_array MercatorMesonic::Price.unscoped.where(mesoyear: @mesoyear).pluck(:mesoprim)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Price.pluck(:mesoprim))
                            .to match_array MercatorMesonic::Price.unscoped.mesocomp.mesoyear..where(c002: 3).pluck(:mesoprim)
    end

    it "has a scope by_kontonummer" do
      expect(MercatorMesonic::Price.by_customer(FIXME!!!).*.c112.uniq).to match_array [FIXME!!!]
    end

  end


  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::Category.new().readonly?).to eql true
  end


  it "returns c013 fo to_s" do
    @price = MercatorMesonic::Price.find_by(mesoprim: "000880-2004-1380")
    expect(@price.to_s).to eql "000880"
  end
end