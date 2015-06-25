require 'spec_helper'

describe MercatorMesonic::KontakteStamm do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::KontakteStamm.table_name).to eql "T045"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::KontakteStamm.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::KontakteStamm.unscoped.mesocomp.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontakteStamm.unscoped.where(mesocomp: @mesocomp).limit(100).pluck(:mesoprim)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::KontakteStamm.unscoped.mesoyear.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontakteStamm.unscoped.where(mesoyear: @mesoyear).limit(100).pluck(:mesoprim)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::KontakteStamm.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::KontakteStamm.unscoped.mesocomp.mesoyear.limit(100).pluck(:mesoprim)
    end

    it "has a scope by email" do
      expect(MercatorMesonic::KontakteStamm.by_email("Wolfgang.Klaus@ctbto.org").count).to eql 3
    end

    it {should belong_to :kontenstamm}
    it {should belong_to :kontenstamm_adresse}
    it {should belong_to :kontenstamm_fakt}
    it {should belong_to :kontenstamm_fibu}
  end


  # ---  Class Methods  --- #

  describe "default order" do
    it "returns mesoprim" do
      expect(MercatorMesonic::KontakteStamm.default_order).to eql :mesoprim
    end
  end


  describe "next kontaktenummer" do
    it "returns the next account number" do
      expect(MercatorMesonic::KontakteStamm.next_kontaktenummer > 21000 ).to eql true
    end
  end


  describe "kontaktenummer_exists" do
    it "returns true if account number exists" do
      expect(MercatorMesonic::KontakteStamm.kontaktenummer_exists?("10000")).to eql true
    end

    it "returns true if account number does not exist" do
      expect(MercatorMesonic::KontakteStamm.kontaktenummer_exists?("9999999")).to eql false
    end
  end


  describe "initialize_mesonic" do
    before :each do
      create(:country)
      @user = create(:user)
      @billing_address = create(:billing_address, user_id: @user.id)
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "initializes a record" do
      expect(MercatorMesonic::KontakteStamm.initialize_mesonic(user: @user,
                                                               billing_address: @billing_address,
                                                               kontonummer: "account number",
                                                               kontaktenummer: "contact number")).to be_a MercatorMesonic::KontakteStamm
    end

    it "sets the attributes" do
      @new_record = MercatorMesonic::KontakteStamm.initialize_mesonic(user: @user,
                                                                      billing_address: @billing_address,
                                                                      kontonummer: "account number",
                                                                      kontaktenummer: "47111")
      expect(@new_record.c033).to eql 0
      expect(@new_record.c040).to eql 1
      expect(@new_record.c042).to eql 0
      expect(@new_record.c043).to eql 0
      expect(@new_record.c054).to eql 0
      expect(@new_record.c059).to eql 0
      expect(@new_record.c060).to eql 0
      expect(@new_record.c035).to eql 2
      expect(@new_record.c001).to eql "Doe"
      expect(@new_record.c002).to eql "John"
      expect(@new_record.c003).to eql "Dr"
      expect(@new_record.c005).to eql "Kärntner Straße 123"
      expect(@new_record.c007).to eql "1234"
      expect(@new_record.c009).to eql "Vienna"
      expect(@new_record.c012).to eql "+43123456789"
      expect(@new_record.c046).to eql "Österreich"
      expect(@new_record.c039).to eql "account number"
      expect(@new_record.c000).to eql 47111
      expect(@new_record.c025).to eql "john.doe@informatom.com"
      expect(@new_record.C061).to eql 47111
      expect(@new_record.C069).to eql 4
      expect(@new_record.mesocomp).to eql @mesocomp
      expect(@new_record.mesoyear).to eql @mesoyear
      expect(@new_record.mesoprim).to eql "47111-" + @mesocomp.to_s + "-" + @mesoyear.to_s
    end
  end


  # ---  Instance Methods  --- #

  it "returns data for to_s" do
    @kontaktestamm = MercatorMesonic::KontakteStamm.find_by(mesoprim: "10000-2004-1380")
    expect(@kontaktestamm.to_s).to eql "112452Wolfgang KLAUS - ---"
  end

  describe "full_name" do
    it "returns formatted full name" do
      @kontaktestamm = MercatorMesonic::KontakteStamm.find_by(mesoprim: "10000-2004-1380")
      expect(@kontaktestamm.full_name).to eql "Wolfgang KLAUS - ---"
    end
  end
end