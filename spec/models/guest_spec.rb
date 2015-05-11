require 'spec_helper'

describe Guest do

  before :each do
    @guest = Guest.new()
  end

  it "responds to administrator?" do
    expect(@guest.administrator?).to be_falsey
  end

  it "responds to sales?" do
    expect(@guest.sales?).to be_falsey
  end

  it "responds to contentmanager?" do
    expect(@guest.contentmanager?).to be_falsey
  end

  it "responds to sales" do
    expect(@guest.sales).to be_falsey
  end

  it "responds to locale?" do
    expect(@guest.locale).to eql(:de)
  end

  it "responds to name?" do
    expect(@guest.name).to eql("Guest")
  end

  it "responds to surname?" do
    expect(@guest.surname).to eql("Guest")
  end

  it "responds to basket?" do
    is_expected.to respond_to :basket
  end
end