require 'spec_helper'

describe Constant do
  it "is valid with key and value" do
    expect(build  :constant).to be_valid
  end

  it {should validate_presence_of :key}
  it {should validate_uniqueness_of :key}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


# ---  CLass Methods  --- #

  describe "office hours" do
    it "returns false out of office hours" do
      create(:office_hours)
      monday_night = Time.new(2015, 05, 11, 4, 00, 0, "+00:00")
      expect(Constant.office_hours?(time: monday_night)).to eql(false)
    end


    it "returns true during office hours" do
      create(:office_hours)
      monday_afternoon = Time.new(2015, 05, 11, 14, 00, 0, "+00:00")
      expect(Constant.office_hours?(time: monday_afternoon)).to eql(true)
    end
  end


  describe "pretty_office_hours" do
    it "returns a string" do
      create(:office_hours)
      expect(Constant.pretty_office_hours.class).to eql(String)
    end
  end


  describe "page_title_prefix" do
    it "returns page_title_prefix" do
      create(:constant_page_title_prefix)
      expect(Constant.page_title_prefix).to eql "some prefix"
    end
  end


  describe "page_title_postfix" do
    it "returns page_title_postfix" do
      create(:constant_page_title_postfix)
      expect(Constant.page_title_postfix).to eql "some postfix"
    end
  end
end