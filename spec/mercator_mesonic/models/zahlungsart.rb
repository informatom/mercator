require 'spec_helper'

describe MercatorMesonic::Zahlungsart do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its class name" do
      expect(MercatorMesonic::Zahlungsart.table_name).to eql "T286"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Zahlungsart.primary_key).to eql "c000"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Zahlungsart.unscoped.mesocomp.pluck(:c000))
                            .to match_array MercatorMesonic::Zahlungsart.unscoped.where(mesocomp: @mesocomp).pluck(:c000)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Zahlungsart.unscoped.mesoyear.pluck(:c000))
                            .to match_array MercatorMesonic::Zahlungsart.unscoped.where(mesoyear: @mesoyear).pluck(:c000)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Zahlungsart.pluck(:c000))
                            .to match_array MercatorMesonic::Zahlungsart.unscoped.mesocomp.mesoyear.pluck(:c000)
    end

    it "has a scope by_account_number" do
      # HAS 20150606: This is just one example, output could change, but code should run ...
      expect(MercatorMesonic::Zahlungsart.by_account_number("000880").pluck(:c000)).to match_array [1001, 1002, 1003, 1004, 1010, 1011]
    end
  end

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Videntifier.new().readonly?).to eql true
  end
end