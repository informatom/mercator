require 'spec_helper'

describe Blogpost do
  it "is valid with title_de, name_de, post_category, content_element" do
    expect(build :blogpost).to be_valid
  end

  it {should validate_presence_of :title_de}

  it {should belong_to :content_element}
  it {should validate_presence_of :content_element}

  it {should belong_to :post_category}
  it {should validate_presence_of :post_category}

  it {should have_many :comments}

  it "is taggable" do
    should respond_to :blogtags
  end

  it "is versioned" do
    should respond_to :versions
  end
end