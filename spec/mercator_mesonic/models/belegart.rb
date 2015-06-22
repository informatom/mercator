require 'spec_helper'

describe MercatorMesonic::Belegart do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Belegart.table_name).to eql "T357"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Belegart.primary_key).to eql "C000"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Belegart.unscoped.mesocomp.pluck(:C000))
                            .to match_array MercatorMesonic::Belegart.unscoped.where(mesocomp: @mesocomp).pluck(:C000)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Belegart.unscoped.mesoyear.pluck(:C000))
                            .to match_array MercatorMesonic::Belegart.unscoped.where(mesoyear: @mesoyear).pluck(:C000)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Belegart.pluck(:C000))
                            .to match_array MercatorMesonic::Belegart.unscoped.mesocomp.mesoyear.pluck(:C000)
    end
  end

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::Belegart.new().readonly?).to eql true
  end
end