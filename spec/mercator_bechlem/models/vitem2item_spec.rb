require 'spec_helper'

describe MercatorBechlem::Vitem2item do

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Vitem2item.new().readonly?).to eql true
  end
end