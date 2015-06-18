require 'spec_helper'

describe MercatorBechlem::Vcategory do

  # ---  Class Methods  --- #

  describe "top_categories" do
    it "returns top categories" do
      @top_ids = [ 145211000, 145212000, 145213000, 145214000, 145215000, 145216000, 145217000,
                   145218000, 145219000, 145221000, 145222000, 145223000, 145224000, 145225000,
                   145226000, 145227000, 145228000, 145229000]
      expect(MercatorBechlem::Vcategory.top_categories).to match_array MercatorBechlem::Vcategory.where(IDCATEGORY: @top_ids)
    end
  end

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Vcategory.new().readonly?).to eql true
  end


  describe "parent" do
    it "returns the parent" do
      @vcategory = MercatorBechlem::Vcategory.find_by(IDCATEGORY: 145211100)
      expect(@vcategory.parent).to eql MercatorBechlem::Vcategory.find_by(IDCATEGORY: 145211000)

    end
  end


  describe "parents" do
    it "returns the parents" do
      @parent_ids = [145220000, 145222000, 145222200]
      @vcategory = MercatorBechlem::Vcategory.find_by(IDCATEGORY: 145222250)
      expect(@vcategory.parents).to match_array MercatorBechlem::Vcategory.where(IDCATEGORY: @parent_ids)
    end
  end


  describe "ancestors" do
    it "returns the parent" do
      @parent_ids = [145220000, 145222000, 145222200]
      @vcategory = MercatorBechlem::Vcategory.find_by(IDCATEGORY: 145222250)
      expect(@vcategory.ancestors).to match_array MercatorBechlem::Vcategory.where(IDCATEGORY: @parent_ids)
    end
  end

  describe "children" do
    it "returns the chiildren" do
      @child_ids = [145211100, 145211200, 145211300, 145211400, 145211500, 145211600]

      @vcategory = MercatorBechlem::Vcategory.find_by(IDCATEGORY: 145211000)
      expect(@vcategory.children).to match_array MercatorBechlem::Vcategory.where(IDCATEGORY: @child_ids)
    end
  end
end