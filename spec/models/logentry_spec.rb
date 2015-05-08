require 'spec_helper'

RSpec.describe Logentry, :type => :model do
  it "is valid with severity, message " do
    expect(build(:logentry)).to be_valid
  end
end