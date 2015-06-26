require 'spec_helper'

describe Sales::MessagesController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @conversation = create(:conversation)
      @instance = create(:message, conversation: @conversation)
      @invalid_attributes = attributes_for(:message, sender_id: @conversation.customer.id,
                                                     conversation_id: @conversation.id,
                                                     reciever_id: @conversation.consultant.id,
                                                     content: nil)
    end

    it_behaves_like("crud except destroy")


    describe 'DELETE #destroy' do
      it "redirects to #index" do
        act_as_admin
        delete :destroy, id: @instance
        expect(response).to be_redirect
      end
    end


    describe 'POST #create' do
      it "publishes message" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.conversation.id.to_s,
                                                        type: "messages")
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/"+ @instance.reciever.id.to_s,
                                                        sender: "Mr. Dr Sammy Sales Representative",
                                                        content: @instance.content)

        post :create, message: attributes_for(:message, conversation_id: @conversation.id,
                                                        sender_id: @conversation.customer.id, reciever_id: @conversation.consultant.id)
      end
    end
  end
end