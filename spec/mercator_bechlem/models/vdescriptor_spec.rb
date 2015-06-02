require 'spec_helper'

describe MercatorBechlem::Vdescriptor do

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Vdescriptor.new().readonly?).to eql true
  end
end