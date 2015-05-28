require 'spec_helper'

describe MessagesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_user

      @conversation = create(:conversation, customer_id: @user.id)
      @instance = create(:message, conversation_id: @conversation.id,
                                   sender_id: @user.id,
                                   reciever_id: @conversation.consultant.id)
      @attributes = attributes_for(:message, conversation_id: @conversation.id,
                                             sender_id: nil,
                                             reciever_id: @conversation.consultant.id)
    end

    it_behaves_like("crud show")
    it_behaves_like("crud index")

    describe 'POST #create' do
      it "redirects to  data it rerenders #new" do
        post :create, message: @attributes
        expect(response).to redirect_to message_path(assigns(:message))
      end

      it "publishes the message" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @conversation.id.to_s,
                                                        type: "messages")
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/"+ @conversation.consultant.id.to_s,
                                                        sender: @user.name,
                                                        content: @instance.content)
        post :create, message: @attributes
      end
    end
  end
end