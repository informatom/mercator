require 'spec_helper'

describe MercatorMesonic::AktMandant do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::AktMandant.table_name).to eql "AktMandant"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::AktMandant.primary_key).to eql "mesocomp"
    end
  end

  describe "mesocomp" do
    it "returns mesocomp" do
      expect(MercatorMesonic::AktMandant.mesoyear).to eql 1380
    end
  end

  describe "mesoyear" do
    it "returns mesoyear" do
      expect(MercatorMesonic::AktMandant.mesocomp).to eql "2004"
    end
  end

  describe "mesocomp_and_year" do
    it "mesocomp_and_year" do
      expect(MercatorMesonic::AktMandant.mesocomp_and_year).to match_array [1380, "2004"]
    end
  end

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::AktMandant.new().readonly?).to eql true
  end
end