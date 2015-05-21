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


  context "inform_sales" do
    it "returns nil if no consultant is logged in" do
      @user = create(:user)
      expect(@user.inform_sales(locale: "en")).to eql nil
    end

    context "if consultants or logged in" do
      before :each do
        @user = create(:user)
        @robot = create(:robot)
        User.send(:remove_const, :ROBOT) # just to avoid warning in the next line
        User::ROBOT = @robot
        @conversation = create(:conversation, customer: @user,
                                              consultant: nil)

        @consultant = create(:sales, logged_in: true)
        @second_consultant = create(:sales, logged_in: true,
                                            email_address: "second_consultant@informatom.com")
        @third_consultant = create(:sales, logged_in: true,
                                           email_address: "third_consultant@informatom.com")
        @fourth_consultant = create(:sales, logged_in: true,
                                            email_address: "fourth_consultant@informatom.com")
        @fifth_consultant = create(:sales, logged_in: true,
                                           email_address: "fifth_consultant@informatom.com")
      end

      it "tries five times to get a consultant to respond" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new conversation?",
                                                        conversation: @conversation.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @second_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new conversation?",
                                                        conversation: @conversation.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @third_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new conversation?",
                                                        conversation: @conversation.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @fourth_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new conversation?",
                                                        conversation: @conversation.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @fifth_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new conversation?",
                                                        conversation: @conversation.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/" + @user.id.to_s,
                                                        type: "messages")
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @user.id.to_s,
                                                        sender: @robot.name,
          content: "Unfortunately, we have no sales representative available for you right now. Please try later or stay at this page.")
        @conversation.inform_sales(locale: "en")
      end

      it "trues only once if call is picked up (that is @conversation.consultant_id is set)" do
        @conversation.update(consultant_id: @consultant.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new conversation?",
                                                        conversation: @conversation.id)
        expect(PrivatePub).not_to receive(:publish_to).with("/0004/personal/" + @second_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new conversation?",
                                                        conversation: @conversation.id)
        @conversation.inform_sales(locale: "en")
      end
    end
  end
end