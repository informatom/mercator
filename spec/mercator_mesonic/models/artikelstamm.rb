require 'spec_helper'

describe MercatorMesonic::Artikelstamm do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Artikelstamm.table_name).to eql "t024"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Artikelstamm.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Artikelstamm.unscoped.mesocomp.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::Artikelstamm.unscoped.where(mesocomp: @mesocomp).limit(100).pluck(:mesoprim)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Artikelstamm.unscoped.mesoyear.limit(100).pluck(:mesoprim))
                            .to match_array MercatorMesonic::Artikelstamm.unscoped.where(mesoyear: @mesoyear).limit(100).pluck(:mesoprim)
    end
  end


  # ---  Instance Methods  --- #


  describe "invoices_by_account_number" do
    it "finds the invoices for an account number" do
      expect(MercatorMesonic::Artikelstamm.invoices_by_account_number(account_number: "661016").class).to eql Array
    end
  end


  describe "open_shipments_by_account_number" do
    it "finds the open_shipments_by_account_number" do
      expect(MercatorMesonic::Artikelstamm.open_shipments_by_account_number(account_number: "661016").class).to eql Array
    end
  end


  describe "open_payments_by_account_number" do
    it "finds the open_payments_by_account_number" do
      expect(MercatorMesonic::Artikelstamm.open_payments_by_account_number(account_number: "661016").class).to eql Array
    end
  end


  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::Artikelstamm.new().readonly?).to eql true
  end
end