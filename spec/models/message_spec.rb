require 'spec_helper'

describe Message do
  it "is valid with name, sender, reciever, conversation" do
    expect(build :message).to be_valid
  end

  it {should validate_presence_of :content}

  it {should belong_to :sender}
  it {should validate_presence_of :sender}

  it {should belong_to :reciever}
  it {should belong_to :conversation}

  it "is versioned" do
    should respond_to :versions
  end
end
