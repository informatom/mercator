require 'spec_helper'

describe Feedback do
  it "is valid with content, user, consultant, conversation" do
    expect(build(:feedback)).to be_valid
  end

  it {should validate_presence_of(:content)}

  it {should belong_to(:user)}
  it {should belong_to(:consultant)}
  it {should belong_to(:conversation)}

  it "is versioned" do
    should respond_to(:versions)
  end
end