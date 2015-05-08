require 'spec_helper'

describe Consumableitem do
  it "is valid with contractitem, position, product_number, contract_type, product_line, description_de, " +
     "description_en, amount, theyield, wholesale_price, term, consumption1, consumption2," +
     "consumption3, consumption4, consumption5, consumption6, balance6" do
    expect(build (:consumableitem)).to be_valid
  end

  it {should belong_to :contractitem}
  it {should validate_presence_of :contractitem}

  it "is versioned" do
    should respond_to(:versions)
  end
end