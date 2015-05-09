require 'spec_helper'

describe Price do
  it "is valid with value, vat, valid_from, valid_to, scale_from, scale_to,
      promatoion" do
    expect(build :price).to be_valid
  end

  it {should validate_presence_of :value}
  it {should validate_presence_of :vat}
  it {should validate_presence_of :scale_from}
  it {should validate_presence_of :scale_to}
  it {should validate_presence_of :valid_from}
  it {should validate_presence_of :valid_to}

  it {should validate_numericality_of :value}
  it {should validate_numericality_of :vat}
  it {should validate_numericality_of :scale_from}
  it {should validate_numericality_of :scale_to}

  it {should belong_to :inventory}
  it {should validate_presence_of :inventory}

  it "is versioned" do
    should respond_to :versions
  end
end
