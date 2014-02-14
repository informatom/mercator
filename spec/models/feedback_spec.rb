require 'spec_helper'

describe Feedback do
  it "is valid with content, user, consultant, conversation" do
    expect(build(:feedback)).to be_valid
  end

  it {should validate_presence_of(:content)}

  it "is versioned" do
    should respond_to(:versions)
  end
end