require 'spec_helper'

describe Feature do
  it "is valid with text_de, text_en, position" do
    expect(build(:feature)).to be_valid
  end

  it {should validate_presence_of(:text_de)}

  it {should validate_presence_of(:position)}

  it {should belong_to(:product)}
  it {should validate_presence_of(:product)}

  it "acts as a list" do
    should respond_to(:move_to_top)
  end

  it "is versioned" do
    should respond_to(:versions)
  end
end
