require 'spec_helper'

describe Download do
  it "is valid with name, document" do
    expect(build(:download)).to be_valid
  end

  it {should validate_presence_of(:name)}

  it "is versioned" do
    should respond_to(:versions)
  end

  it "has a document attached" do
    should respond_to(:document)
  end

  it {should belong_to(:conversation)}
  it {should validate_presence_of(:conversation)}
end
