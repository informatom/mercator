require 'spec_helper'

describe Link do
  it "is valid with title, url, conversation" do
    expect(build(:link)).to be_valid
  end

  it {should validate_presence_of(:url)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it {should belong_to(:conversation)}
end