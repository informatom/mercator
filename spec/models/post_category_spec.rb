require 'spec_helper'

describe PostCategory do
  it "is valid with name_de, name_en, ancestry" do
    expect(build :post_category).to be_valid
  end

  it "is versioned" do
    should respond_to :versions
  end
end