require 'spec_helper'

describe MercatorBechlem::Vitem do

  it {should have_many :item2items}

  # ---  Instance Methods  --- #

  it "is readonly" do
    expect(MercatorBechlem::Vitem.new().readonly?).to eql true
  end
end