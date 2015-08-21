require 'spec_helper'

describe Sales::ConversationsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @user = create(:user)
      @second_sales = create(:second_sales)
      @instance = create(:conversation, customer_id: @user.id,
                                        consultant_id: @sales.id)
      @invalid_attributes = attributes_for(:conversation, name: nil)
    end


    it_behaves_like("crud except destroy")


    describe 'DELETE #destroy' do
      it "redirects to sales_conversations_path" do
        act_as_admin
        delete :destroy, id: @instance
        expect(response).to redirect_to sales_conversations_path
      end
    end


    describe "GET #index" do
      it "searches for name" do
        get :index, search: "Freudliche"
        expect(assigns(:conversations).count).to eql 1
      end

      it "searches for consultant id" do
        get :index, search: @sales.id
        expect(assigns(:conversations).count).to eql 1
      end

      it "searches for customer id" do
        get :index, search: @user.id
        expect(assigns(:conversations).count).to eql 1
      end

      it "finds nothing if expression not present in record" do
        get :index, search: "you cant find this"
        expect(assigns(:conversations).count).to eql 0
      end
    end


    describe "GET #show" do
      it "creates an empty message, link and suggestion" do
        get :show, id: @instance.id
        expect(assigns(:message).class).to eql Message
        expect(assigns(:link).class).to eql Link
        expect(assigns(:suggestion).class).to eql Suggestion
      end

      it "sets in session the current_conversation_id" do
        get :show, id: @instance.id
        expect(session[:current_conversation_id]).to eql(@instance.id)
      end
    end


    describe "POST #refresh" do
      it "loads the conversation" do
        xhr :post, :refresh, id: @instance.id, render: "whatever"
        expect(assigns(:conversation)).to eql @instance
      end
    end


    describe "GET #take" do
      it "loads the conversation" do
        get :take, id: @instance.id
        expect(assigns(:conversation)).to eql @instance
      end

      it "updates the consultant" do
        @instance.update(consultant_id: @second_sales.id)
        expect(@instance.consultant.id).to eql @second_sales.id
        get :take, id: @instance.id

        @instance.reload
        expect(@instance.consultant.id).to eql @sales.id
      end

      it "creates a new massage" do
        @instance.update(consultant_id: @second_sales.id)
        get :take, id: @instance.id

        @instance.reload
        expect(@instance.messages.first.reciever_id).to eql @user.id
        expect(@instance.messages.first.sender_id).to eql @sales.id
        expect(@instance.messages.first.content).to eql "Hello! My name is Sammy Sales Representative. How can I help you?"
      end

      it "publishes to conversations" do
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/conversations/"+ @instance.id.to_s,
                                                        type: "consultant")
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/conversations/"+ @instance.id.to_s,
                                                        type: "messages")
        get :take, id: @instance.id
      end

      it "redirects to sales conversation path" do
        get :take, id: @instance.id
        expect(response).to redirect_to sales_conversation_path(@instance)
      end
    end


    describe "POST #typing" do
      it "publishes to conversations" do
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/conversations/"+ @instance.id.to_s,
                                                        type: "typing",
                                                        message: "my message")
        xhr :post, :typing, id: @instance.id,
                      message: "my message"
      end

      it "renders nothing for xhr request" do
        xhr :post, :typing, id: @instance.id,
                   message: "my message"
        expect(response.body).to eql(" ")
      end
    end


    describe "upload" do
      it "is available for sales" do
        expect(@instance.lifecycle.can_upload? @sales).to be
      end

      it "is available for cutstomer" do
        expect(@instance.lifecycle.can_upload? @user).to be
      end
    end
  end
end