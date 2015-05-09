require 'spec_helper'

describe PageTemplate do
  it "is valid with name, content" do
    expect(build :page_template).to be_valid
  end

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}

  it {should validate_presence_of :content}

  it {should have_many :webpages}

  it "is versioned" do
    should respond_to :versions
  end
end