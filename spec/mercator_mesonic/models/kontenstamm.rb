require 'spec_helper'

describe MercatorMesonic::Kontenstamm do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Kontenstamm.table_name).to eql "T055"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Kontenstamm.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Kontenstamm.unscoped.mesocomp.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::Kontenstamm.unscoped.where(mesocomp: @mesocomp).limit(100).pluck(:mesoprim)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Kontenstamm.unscoped.mesoyear.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::Kontenstamm.unscoped.where(mesoyear: @mesoyear).limit(100).pluck(:mesoprim)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Kontenstamm.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::Kontenstamm.unscoped.mesocomp.mesoyear.limit(100).pluck(:mesoprim)
    end

    it "has a scope interessenten" do
      expect(MercatorMesonic::Kontenstamm.interessenten.count).to eql 1
    end

    it "has a scope interessent" do
      expect(MercatorMesonic::Kontenstamm.interessent.count > 3400 ).to eql true
    end

    it {should have_one :kontenstamm_adresse}
  end


  # ---  Class Methods  --- #

  describe "default order" do
    it "returns mesoprim" do
      expect(MercatorMesonic::Kontenstamm.default_order).to eql :mesoprim
    end
  end


  describe "next kontonummer" do
    it "returns the next account number" do
      expect(MercatorMesonic::Kontenstamm.next_kontonummer.first(3)).to eql "1I2"
    end
  end


  describe "kontonummer_exists" do
    it "returns true if account number exists" do
      expect(MercatorMesonic::Kontenstamm.kontonummer_exists?("000880")).to eql true
    end

    it "returns true if account number does not exist" do
      expect(MercatorMesonic::Kontenstamm.kontonummer_exists?("not existing")).to eql false
    end
  end

  describe "initialize_mesonic" do
    before :each do
      @user = create(:user)
      @timestamp = Time.now
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "initializes a record" do
      expect(MercatorMesonic::Kontenstamm.initialize_mesonic(user: @user,
                                                             kontonummer: "account number",
                                                             timestamp: @timestamp)).to be_a MercatorMesonic::Kontenstamm
    end

    it "sets the attributes" do
      @new_record = MercatorMesonic::Kontenstamm.initialize_mesonic(user: @user,
                                                                   kontonummer: "account number",
                                                                   timestamp: @timestamp)
      expect(@new_record.c146).to eql 0
      expect(@new_record.c155).to eql 0
      expect(@new_record.c156).to eql 0
      expect(@new_record.c172).to eql 0
      expect(@new_record.C253).to eql 0
      expect(@new_record.C254).to eql 0
      expect(@new_record.mesosafe).to eql 0
      expect(@new_record.c002).to eql "account number"
      expect(@new_record.c004).to eql "4"
      expect(@new_record.c003).to eql "Mr. John Doe"
      expect(@new_record.c086).to eql @timestamp
      expect(@new_record.c102).to eql "account number"
      expect(@new_record.c103).to eql "account number"
      expect(@new_record.c127).to eql "050-"
      expect(@new_record.c069).to eql 2
      expect(@new_record.mesocomp).to eql @mesocomp
      expect(@new_record.mesoyear).to eql @mesoyear
      expect(@new_record.mesoprim).to eql "account number-" + @mesocomp.to_s + "-" + @mesoyear.to_s
    end
  end


  # ---  Instance Methods  --- #

  it "returns name for to_s" do
    @kontenstamm = MercatorMesonic::Kontenstamm.find_by(mesoprim: "000880-2004-1380")
    expect(@kontenstamm.to_s).to eql "INGRAM-MACROTRON GmbH"
  end

  describe "kunde?" do
    it "returns true for customers" do
      @kontenstamm = MercatorMesonic::Kontenstamm.find_by(mesoprim: "000880-2004-1380")
      expect(@kontenstamm.kunde?).to eql true
    end

    it "returns false for potential buyer" do
      @kontenstamm = MercatorMesonic::Kontenstamm.find_by(mesoprim: "1I00001-2004-1380")
      expect(@kontenstamm.kunde?).to eql false
    end
  end

  describe "interessent?" do
    it "returns false for customers" do
      @kontenstamm = MercatorMesonic::Kontenstamm.find_by(mesoprim: "000880-2004-1380")
      expect(@kontenstamm.interessent?).to eql false
    end

    it "returns false for potential buyer" do
      @kontenstamm = MercatorMesonic::Kontenstamm.find_by(mesoprim: "1I00001-2004-1380")
      expect(@kontenstamm.interessent?).to eql true
    end
  end
end