require 'spec_helper'

describe Download do
  it "is valid with name, document, photo" do
    expect(build :download).to be_valid
  end

  it {should validate_presence_of :name}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "has a document attached" do
    is_expected.to respond_to :document
  end

  it "has a photo attached" do
    is_expected.to respond_to :photo
  end

  it {should belong_to :conversation}
  it {should validate_presence_of :conversation}
end