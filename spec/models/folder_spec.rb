require 'spec_helper'

describe Folder do
  it "is valid with name, ancestry, position" do
    expect(build :folder).to be_valid
  end

  it {should validate_presence_of :name}
  it {should validate_presence_of :position}
  it {should validate_numericality_of :position}
  it {should have_many :content_elements}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "is in a tree structure" do
    is_expected.to respond_to :parent
    is_expected.to respond_to :children
  end
end