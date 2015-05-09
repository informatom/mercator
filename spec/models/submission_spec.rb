require 'spec_helper'

describe Submission do
  it "is valid with name, email, phone, message, answer" do
    expect(build :submission).to be_valid
  end

  it {should validate_presence_of :name}
  it {should validate_presence_of :email}
  it {should validate_presence_of :answer}

  it { should allow_value("8").for(:answer) }
  it { should_not allow_value("anything else").for(:answer) }

  it "is versioned" do
    should respond_to :versions
  end
end