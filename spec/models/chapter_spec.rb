require 'spec_helper'

describe Chapter do
  it "is valid with podcast, start, title, href" do
    expect(build :chapter).to be_valid
  end

  it {should validate_presence_of :start}
  it {should validate_presence_of :title}

  it {should belong_to :podcast}

  it "is versioned" do
    should respond_to :versions
  end
end