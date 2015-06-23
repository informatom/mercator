require 'spec_helper'

describe MercatorMesonic::KontenstammAdresse do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::KontenstammAdresse.table_name).to eql "T051"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::KontenstammAdresse.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::KontenstammAdresse.unscoped.mesocomp.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammAdresse.unscoped.where(mesocomp: @mesocomp).limit(100).pluck(:mesoprim)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::KontenstammAdresse.unscoped.mesoyear.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammAdresse.unscoped.where(mesoyear: @mesoyear).limit(100).pluck(:mesoprim)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::KontenstammAdresse.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontenstammAdresse.unscoped.mesocomp.mesoyear.limit(100).pluck(:mesoprim)
    end

    it {should validate_presence_of :lastname}
    it {should validate_presence_of :street}
    it {should validate_presence_of :city}
    it {should validate_presence_of :postal}
  end


  # ---  Class Methods  --- #

  describe "default order" do
    it "returns mesoprim" do
      expect(MercatorMesonic::KontenstammAdresse.default_order).to eql :mesoprim
    end
  end


  describe "initialize_mesonic" do
    before :each do
      create(:country)
      @billing_address = create(:billing_address)
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "initializes a record" do
      expect(MercatorMesonic::KontenstammAdresse.initialize_mesonic(billing_address: @billing_address,
                                                                    kontonummer: "account number")).to be_a MercatorMesonic::KontenstammAdresse
    end

    it "sets the attributes" do
      @new_record = MercatorMesonic::KontenstammAdresse.initialize_mesonic(billing_address: @billing_address,
                                                                           kontonummer: "account number")
      expect(@new_record.c157).to eql 0
      expect(@new_record.c182).to eql 0
      expect(@new_record.C241).to eql 0
      expect(@new_record.c019).to eql "+43123456789"
      expect(@new_record.c050).to eql "Kärntner Straße 123"
      expect(@new_record.c051).to eql "1234"
      expect(@new_record.c052).to eql "Vienna"
      expect(@new_record.c053).to eql "Department of Despair"
      expect(@new_record.c123).to eql "Österreich"
      expect(@new_record.c179).to eql "Dr"
      expect(@new_record.c180).to eql "John"
      expect(@new_record.c181).to eql "Doe"
      expect(@new_record.c001).to eql "account number"
      expect(@new_record.c116).to eql "john.doe@informatom.com"
      expect(@new_record.mesocomp).to eql @mesocomp
      expect(@new_record.mesoyear).to eql @mesoyear
      expect(@new_record.mesoprim).to eql "account number-" + @mesocomp.to_s + "-" + @mesoyear.to_s
    end
  end


  # ---  Instance Methods  --- #

  it "returns date for to_s" do
    @kontenstamm = MercatorMesonic::KontenstammAdresse.find_by(mesoprim: "000880-2004-1380")
    expect(@kontenstamm.to_s).to eql "1020Wien,Freudenauer Hafenstraße 20-22"
  end

  describe "telephone_full" do
    it "returns formatted phone number" do
      @kontenstamm = MercatorMesonic::KontenstammAdresse.find_by(mesoprim: "000888-2004-1380")
      expect(@kontenstamm.telephone_full).to eql "  408 15 43"
    end
  end

  describe "fax_full" do
    it "returns formatted phone number" do
      @kontenstamm = MercatorMesonic::KontenstammAdresse.find_by(mesoprim: "000888-2004-1380")
      expect(@kontenstamm.fax_full).to eql "  408 15 43 390"
    end
  end
end