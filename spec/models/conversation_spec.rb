require 'spec_helper'

describe Conversation do
  it "is valid with name, customer, consultant" do
    expect(build :conversation).to be_valid
  end

  it {should validate_presence_of :name}

  it {should belong_to :customer}
  it {should validate_presence_of :customer}

  it {should belong_to :consultant}

  it {should have_many :downloads}
  it {should have_many :messages}
  it {should have_many :links}
  it {should have_many :offers}
  it {should have_many :baskets}
  it {should have_many :products}
  it {should have_many :suggestions}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  #--- Instance Methods ---#

  context "collaborators" do
    it "gives an array with customer and consultant" do
      @conversation = create(:conversation)
      expect(@conversation.collaborators).to eql [@conversation.consultant, @conversation.customer]
    end
  end


  context "last_link" do
    it "returns tha last link" do
      @conversation = create(:conversation)
      @link = create(:link, created_at: Time.now - 1.hour,
                            conversation: @conversation)
      @later_link = create(:link, conversation: @conversation)
      expect(@conversation.last_link).to eql @later_link
    end
  end


  context "inform_sales", focus: true do
    pending "pending"
  end
end