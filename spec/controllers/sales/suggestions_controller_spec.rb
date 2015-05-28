require 'spec_helper'

describe Sales::SuggestionsController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @instance = create(:suggestion)
      @invalid_attributes = attributes_for(:suggestion, product_id: nil)
    end

    it_behaves_like("crud actions")


    describe 'DELETE #destroy' do
      it "publishes suggestions" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.conversation.id.to_s,
                                                        type: "suggestions")
        delete :destroy, id: @instance
      end
    end


    describe 'PATCH #update' do
      it "publishes suggestions" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.conversation.id.to_s,
                                                        type: "suggestions")
        patch :update, id: @instance,
                       @instance.class.to_s.underscore => @invalid_attributes
      end
    end


    describe 'POST #create' do
      it "publishes suggestions" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.conversation.id.to_s,
                                                        type: "suggestions")
        post :create, suggestion: attributes_for(:suggestion, conversation_id: @instance.conversation.id)
      end
    end


    describe 'GET #show' do
      it "sets current conversation id in session " do
        get :show, id: @instance
        expect(session[:current_conversation_id]).to eql @instance.id
      end
    end
  end
end