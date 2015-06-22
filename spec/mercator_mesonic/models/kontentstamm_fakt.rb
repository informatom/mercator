require 'spec_helper'

describe MercatorMesonic::KontenstammFakt do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::KontenstammFakt.table_name).to eql "T054"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::KontenstammFakt.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::KontenstammFakt.unscoped.mesocomp.pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammFakt.unscoped.where(mesocomp: @mesocomp).pluck(:mesoprim)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::KontenstammFakt.unscoped.mesoyear.pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammFakt.unscoped.where(mesoyear: @mesoyear).pluck(:mesoprim)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::KontenstammFakt.pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammFakt.unscoped.mesocomp.mesoyear.pluck(:mesoprim)
    end

    it "has a scope by_kontonummer" do
      expect(MercatorMesonic::KontenstammFakt.by_kontonummer("000880").*.c112.uniq).to match_array ["000880"]
    end

    it {should have_many :zahlungsarten}
    it {should have_one :belegart}
  end


  # ---  Class Methods  --- #

  describe "default order" do
    it "returns mesoprim" do
      expect(MercatorMesonic::KontenstammFakt.dtefault_order).to eql :mesoprim
    end
  end


  describe "initialize_mesonic" do
    it "initializes a record" do
      expect(MercatorMesonic::KontenstammFakt.initialize_mesonic(kontonummer: 4711,
                                                                 email: "some.email@mercator.informatom.com")).to be_a MercatorMesonic::KontenstammFakt
    end

    it "sets the attributes" do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
      @new_record = MercatorMesonic::KontenstammFakt.initialize_mesonic(kontonummer: 4711,
                                                                        email: "some.email@mercator.informatom.com")
      expect(@new_record.c060).to eql 0.0
      expect(@new_record.c062).to eql 0.0
      expect(@new_record.c068).to eql 0.0
      expect(@new_record.c070).to eql 0
      expect(@new_record.c071).to eql 0
      expect(@new_record.c072).to eql 0
      expect(@new_record.c108).to eql 0
      expect(@new_record.c109).to eql 0
      expect(@new_record.c110).to eql 0
      expect(@new_record.c111).to eql 0
      expect(@new_record.c113).to eql 0
      expect(@new_record.c132).to eql 0
      expect(@new_record.c133).to eql 0
      expect(@new_record.c134).to eql 0
      expect(@new_record.c148).to eql 0
      expect(@new_record.c149).to eql 0
      expect(@new_record.c150).to eql 0
      expect(@new_record.c171).to eql 0.0
      expect(@new_record.C184).to eql 0
      expect(@new_record.c120).to eql "0"
      expect(@new_record.c065).to eql 99
      expect(@new_record.c066).to eql 3
      expect(@new_record.c077).to eql "21"
      expect(@new_record.c107).to eql 17
      expect(@new_record.c112).to eql 4711
      expect(@new_record.c121).to eql 1
      expect(@new_record.c183).to eql 3
      expect(@new_record.C187).to eql "some.email@mercator.informatom.com"
      expect(@new_record.mesocomp).to eql @mesocomp
      expect(@new_record.mesoyear).to eql @mesoyear
      expect(@new_record.mesoprim).to eql "4711-" + @mesocomp.to_s + "-" + @mesoyear.to_s
    end
  end


  # ---  Instance Methods  --- #

  it "returns c112 fo to_s" do
    @kontenstamm_fakt = MercatorMesonic::KontenstammFakt.find_by(mesoprim: "000880-2004-1380")
    expect(@kontenstamm_fakt.to_s).to eql "000880"
  end
end