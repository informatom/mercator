require 'spec_helper'

describe MercatorBechlem::Vbrand do

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Vbrand.new().readonly?).to eql true
  end
end