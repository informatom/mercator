require 'spec_helper'

describe MercatorBechlem::VitemPrinter do

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::VitemPrinter.new().readonly?).to eql true
  end
end