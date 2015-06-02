require 'spec_helper'

describe MercatorBechlem::VitemMedia do

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::VitemMedia.new().readonly?).to eql true
  end
end