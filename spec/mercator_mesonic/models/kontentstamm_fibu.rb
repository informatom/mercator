require 'spec_helper'

describe MercatorMesonic::KontenstammFibu do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::KontenstammFibu.table_name).to eql "T058"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::KontenstammFibu.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::KontenstammFibu.unscoped.mesocomp.pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammFibu.unscoped.where(mesocomp: @mesocomp).pluck(:mesoprim)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::KontenstammFibu.unscoped.mesoyear.pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammFibu.unscoped.where(mesoyear: @mesoyear).pluck(:mesoprim)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::KontenstammFibu.pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammFibu.unscoped.mesocomp.mesoyear.pluck(:mesoprim)
    end
  end


  # ---  Class Methods  --- #

  describe "default order" do
    it "returns mesoprim" do
      expect(MercatorMesonic::KontenstammFibu.default_order).to eql :mesoprim
    end
  end


  describe "initialize_mesonic" do
    it "initializes a record" do
      expect(MercatorMesonic::KontenstammFibu.initialize_mesonic(kontonummer: 4711)).to be_a MercatorMesonic::KontenstammFibu
    end

    it "sets the attributes" do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
      @new_record = MercatorMesonic::KontenstammFibu.initialize_mesonic(kontonummer: 4711)
      expect(@new_record.c005).to eql 0
      expect(@new_record.c006).to eql 0
      expect(@new_record.c009).to eql 0
      expect(@new_record.c012).to eql 0
      expect(@new_record.c057).to eql 0
      expect(@new_record.c058).to eql 0.0
      expect(@new_record.c059).to eql 0
      expect(@new_record.c061).to eql 0.0
      expect(@new_record.c063).to eql 0
      expect(@new_record.c067).to eql 0
      expect(@new_record.c114).to eql 0
      expect(@new_record.c115).to eql 0
      expect(@new_record.c124).to eql 0
      expect(@new_record.c135).to eql 0
      expect(@new_record.c136).to eql 0
      expect(@new_record.c137).to eql 0
      expect(@new_record.c151).to eql 0
      expect(@new_record.c153).to eql 0.0
      expect(@new_record.c164).to eql 0
      expect(@new_record.c173).to eql 0
      expect(@new_record.c174).to eql 0
      expect(@new_record.c175).to eql 0
      expect(@new_record.c176).to eql 0
      expect(@new_record.C185).to eql 0
      expect(@new_record.C186).to eql 0
      expect(@new_record.C189).to eql 0.0
      expect(@new_record.C190).to eql 0.0
      expect(@new_record.c007).to eql "1300"
      expect(@new_record.c008).to eql "1300"
      expect(@new_record.c100).to eql 17
      expect(@new_record.c104).to eql 4711
      expect(@new_record.c117).to eql 4711
      expect(@new_record.c163).to eql -1
      expect(@new_record.mesocomp).to eql @mesocomp
      expect(@new_record.mesoyear).to eql @mesoyear
      expect(@new_record.mesoprim).to eql "4711-" + @mesocomp.to_s + "-" + @mesoyear.to_s
    end
  end


  # ---  Instance Methods  --- #

  it "returns kontonummer fo to_s" do
    @kontenstamm_fibu = MercatorMesonic::KontenstammFibu.find_by(mesoprim: "000880-2004-1380")
    expect(@kontenstamm_fibu.to_s).to eql "000880"
  end
end