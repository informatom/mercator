require 'spec_helper'

describe MercatorMesonic::Category do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Category.table_name).to eql "t309"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Category.primary_key).to eql "mesoprim"
    end
  end

  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Category.unscoped.mesocomp.pluck(:C000))
                            .to match_array MercatorMesonic::Category.unscoped.where(mesocomp: @mesocomp).pluck(:C000)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Category.unscoped.mesoyear.pluck(:C000))
                            .to match_array MercatorMesonic::Category.unscoped.where(mesoyear: @mesoyear).pluck(:C000)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Category.pluck(:C000))
                            .to match_array MercatorMesonic::Category.unscoped.mesocomp.mesoyear.pluck(:C000)
    end
  end

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::Category.new().readonly?).to eql true
  end


  describe "parent_key" do
    it "calculates the parent key" do
       @category = MercatorMesonic::Category.find_by(c000: "00020-00010-00061-00000-00000")
       expect(@category.parent_key).to eql "00020-00010-00000-00000-00000"
    end
  end


  describe "comment" do
    it "filters the comment to be propert utf8" do
      @category = MercatorMesonic::Category.find_by(c000: "00070-00020-00090-00000-00000")
      expect(@category.comment).to eql "\r\n\r\n Verbrauchsmaterial\r\n\r\n"
    end
  end
end