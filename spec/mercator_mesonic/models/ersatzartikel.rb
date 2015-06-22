require 'spec_helper'

describe MercatorMesonic::Ersatzartikel do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Ersatzartikel.table_name).to eql "t359"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Ersatzartikel.primary_key).to eql "mesokey"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      # HAS 20150606: Too many items, so we just compare the count and compare the first 100
      expect(MercatorMesonic::Ersatzartikel.unscoped.mesocomp.limit(100).pluck(:mesokey))
                            .to match_array MercatorMesonic::Ersatzartikel.unscoped.where(mesocomp: @mesocomp).limit(100).pluck(:mesokey)
      expect(MercatorMesonic::Ersatzartikel.unscoped.mesocomp.count)
                            .to eql MercatorMesonic::Ersatzartikel.unscoped.where(mesocomp: @mesocomp).count

    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Ersatzartikel.unscoped.mesoyear.pluck(:mesokey))
                            .to match_array MercatorMesonic::Ersatzartikel.unscoped.where(mesoyear: @mesoyear).pluck(:mesokey)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Ersatzartikel.pluck(:mesokey))
                            .to match_array MercatorMesonic::Ersatzartikel.unscoped.mesocomp.mesoyear.pluck(:mesokey)
    end
  end


  describe "self.import_relations" do
    it "returns currently nothing" do
      # HAS 20140606: this is strange, but so what?
      expect(MercatorMesonic::Ersatzartikel.import_relations).to match_array []
    end
  end

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::Ersatzartikel.new().readonly?).to eql true
  end
end