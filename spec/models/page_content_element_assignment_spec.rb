require 'spec_helper'

describe PageContentElementAssignment do
  it "is valid with page, content_element" do
    expect(build :page_content_element_assignment).to be_valid
  end

  it {should validate_presence_of :used_as}
  it {should validate_uniqueness_of :used_as}

  it {should belong_to :webpage}
  it {should validate_presence_of :webpage}

  it {should belong_to :content_element}

  it "is versioned" do
    is_expected.to respond_to :versions
  end
end