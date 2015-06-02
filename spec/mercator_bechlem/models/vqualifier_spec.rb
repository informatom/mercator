require 'spec_helper'

describe MercatorBechlem::Vqualifier do

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Vqualifier.new().readonly?).to eql true
  end
end