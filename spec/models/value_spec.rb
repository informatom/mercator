require 'spec_helper'

describe Value do
  it "is overspecified with title_de, title_en, amount, unit_de, unit_en, flag" do
    expect(build(:value)).not_to be_valid
  end

  it "is valid with title_de, title_en" do
    expect(build(:value, state: "textual", amount: nil, unit_de: nil, unit_en: nil, flag: nil)).to be_valid
  end

  it "is valid with title_de, title_en, unit_de, unit_en" do
    expect(build(:value, state: "textual", amount: nil, flag: nil)).to be_valid
  end

  it "is valid with amount" do
    expect(build(:value, state: "numeric", title_de: nil, title_en: nil, unit_de: nil, unit_en: nil, flag: nil)).to be_valid
  end

  it "is valid with amount, unit_de, unit_en" do
    expect(build(:value, state: "numeric", title_de: nil, title_en: nil, flag: nil)).to be_valid
  end

  it "is valid with flag" do
    expect(build(:value, state: "flag", title_de: nil, title_en: nil, amount: nil, unit_de: nil, unit_en: nil)).to be_valid
  end

  it {should belong_to(:property_group)}
  it {should validate_presence_of(:property_group)}

  it {should belong_to(:property)}
  it {should validate_presence_of(:property)}

  it {should belong_to(:product)}
  it {should validate_presence_of(:product)}

  it {should validate_numericality_of(:amount)}

  it "is versioned" do
    should respond_to(:versions)
  end
end