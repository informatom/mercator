require 'spec_helper'

describe MercatorBechlem::VitemSupply do

  # ---  Class Methods  --- #

  describe "for_category_id" do
    it "return category specific supplies" do
      expect(MercatorBechlem::VitemSupply.for_category_id(145200000).first.IDCATEGORY.to_s).to include "1452"
      expect(MercatorBechlem::VitemSupply.for_category_id(145200000).first.BRAND).to include "HP"
    end
  end


  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::VitemSupply.new().readonly?).to eql true
  end
end