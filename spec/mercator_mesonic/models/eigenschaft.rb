require 'spec_helper'

describe MercatorMesonic::Eigenschaft do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Eigenschaft.table_name).to eql "t070"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Eigenschaft.primary_key).to eql "mesokey"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Eigenschaft.unscoped.mesocomp.pluck(:mesokey))
                            .to match_array MercatorMesonic::Eigenschaft.unscoped.where(mesocomp: @mesocomp).pluck(:mesokey)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Eigenschaft.unscoped.mesoyear.pluck(:mesokey))
                            .to match_array MercatorMesonic::Eigenschaft.unscoped.where(mesoyear: @mesoyear).pluck(:mesokey)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Eigenschaft.pluck(:mesokey))
                            .to match_array MercatorMesonic::Eigenschaft.unscoped.mesocomp.mesoyear.pluck(:mesokey)
    end
  end

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Videntifier.new().readonly?).to eql true
  end
end