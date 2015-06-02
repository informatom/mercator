require 'spec_helper'

describe MercatorBechlem::Videntifier do

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Videntifier.new().readonly?).to eql true
  end
end