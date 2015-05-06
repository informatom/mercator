require 'spec_helper'

describe Comment do
  it "is valid with user, blogpost, podcast, content, ancestry," do
    expect(build (:comment)).to be_valid
  end

  it {should validate_presence_of(:content)}

  it {should belong_to(:user)}
  it {should belong_to(:blogpost)}
  it {should belong_to(:podcast)}

  it "is versioned" do
    should respond_to(:versions)
  end
end