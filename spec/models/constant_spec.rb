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


# Class Methods

  context "office hours" do
    it "returns false out of office hours" do
      monday_night = Time.new(2015, 05, 11, 4, 00, 0, "+00:00")
      expect(Constant.office_hours?(time: monday_night)).eql? false
    end

    it "returns true during office hours" do
      monday_afternoon = Time.new(2015, 05, 11, 14, 00, 0, "+00:00")
      expect(Constant.office_hours?(time: monday_afternoon)).eql? true
    end
  end

  context "pretty_office_hours" do
    it "returns a string" do
      expect(Constant.pretty_office_hours.class).eql? String
    end
  end
end