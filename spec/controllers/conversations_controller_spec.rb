require 'spec_helper'

describe ConversationsController, :type => :controller do
  before :each do
    no_redirects and act_as_user

    User.send(:remove_const, :ROBOT) # just to avoid warning in the next line
    User::ROBOT = create(:robot)
    create(:office_hours)

    @sales = create(:sales)
    @conversation = create(:conversation, customer_id: @user.id,
                                          consultant_id: @sales.id)
    @attributes = attributes_for(:conversation, customer_id: User::ROBOT.id,
                                                consultant_id: @sales.id,
                                                name: "my conversation")
  end


  describe "POST #refresh" do
    it "reads inventory if given" do
      post :refresh, id: @conversation.id
      expect(assigns(:conversation)).to eql @conversation
    end
  end


  describe "GET #show" do
    it "prepares a message" do
      get :show, id: @conversation.id
      expect(assigns(:message)).to be_a Message
    end

    it "the attributes are set" do
      get :show, id: @conversation.id
      expect(assigns(:message).conversation_id).to eql @conversation.id
      expect(assigns(:message).sender_id).to eql @user.id
    end

    it "the customer shows, it's a message to the consultant" do
      get :show, id: @conversation.id
      expect(assigns(:message).reciever_id).to eql @conversation.consultant_id
    end

    it "another sales shows, it's a message to the customer" do
      act_as_sales
      get :show, id: @conversation.id
      expect(assigns(:message).reciever_id).to eql @conversation.customer_id
    end
  end


  context "lifecycle actions" do
    describe "GET #initiate" do
      it "creates a conversation for the customer" do
        get :initiate
        expect(assigns(:conversation).customer).to eql @user
      end

      it "updates the basket" do
        get :initiate
        expect(@user.basket.conversation_id).to eql assigns(:conversation).id
      end

      it "reads the country code" do
        create(:holiday_country_code)
        get :initiate
        expect(assigns(:holiday_country_code)).to eql :es
      end

      it "creates sets message content for holidays" do
        allow(Holidays).to receive(:on).with(Date.today, :at) { [true] }
        get :initiate
        expect(assigns(:message_content)).to eql "Today, we are on holidays. Please feel free to " +
                                                 "leave us a message!"
      end

      it "creates sets message content for office hours" do
        allow(Constant).to receive(:office_hours?) { true }
        get :initiate
        expect(assigns(:message_content)).to eql "Hello! My name is Albert Robot. Please give me I" +
                                                 " title for your call and I'm getting a sales " +
                                                 "representative for you."
      end

      it "creates sets message content for holidays" do
        allow(Constant).to receive(:office_hours?) { false }
        get :initiate
        expect(assigns(:message_content)).to eql "You are contacting us outside office hours. They" +
                                                 " are Mon: 8:30-17:00 Tue: 8:30-17:00 Wed: " +
                                                 "8:30-17:00 Thu: 8:30-17:00 Fri: 8:30-12:30."
      end

      it "creates a message with all parameters set" do
        get :initiate
        expect(assigns(:conversation).messages.first.reciever_id).to eql @user.id
        expect(assigns(:conversation).messages.first.sender_id).to eql User::ROBOT.id
        expect(assigns(:conversation).messages.first.content).to eql assigns(:message_content)
      end

      it "is available" do
        expect(Conversation::Lifecycle.can_initiate? @user).to be
      end
    end


    describe "POST #do_initiate" do
      it "updates the customer" do
        post :do_initiate, conversation: @attributes
        expect(assigns(:conversation).customer_id).to eql @user.id
      end

      it "informs sales" do
        expect_any_instance_of(Conversation).to receive_message_chain(:delay, :inform_sales)
        post :do_initiate, conversation: @attributes
      end
    end


    describe "POST #call_for_consultant" do
      it "clears the consultant" do
        get :call_for_consultant, id: @conversation.id
        expect(assigns(:conversation).consultant_id).to eql nil
      end

      it "informs sales" do
        expect_any_instance_of(Conversation).to receive_message_chain(:delay, :inform_sales)
        get :call_for_consultant, id: @conversation.id
      end

      it "is available for customer" do
        expect(@conversation.lifecycle.can_call_for_consultant? @user).to be
      end
    end


    describe "POST #do_feedback" do
      it "creates a feedback" do
        post :do_feedback, id: @conversation.id, conversation: { content: "some content" }
        expect(assigns(:feedback).content).to eql "some content"
      end

      it "mode is all, user, consultant and conversation are set" do
        post :do_feedback, id: @conversation.id, conversation: { content: "some content",
                                                                 mode: "all"}
        expect(assigns(:feedback).user_id).to eql @user.id
        expect(assigns(:feedback).conversation_id).to eql @conversation.id
        expect(assigns(:feedback).consultant_id).to eql @sales.id
      end

      it "mode is user, user is set" do
        post :do_feedback, id: @conversation.id, conversation: { content: "some content",
                                                                 mode: "user"}
        expect(assigns(:feedback).user_id).to eql @user.id
        expect(assigns(:feedback).conversation_id).to eql nil
        expect(assigns(:feedback).consultant_id).to eql nil
      end

      it "mode is consultant, consultant is set" do
        post :do_feedback, id: @conversation.id, conversation: { content: "some content",
                                                                 mode: "consultant"}
        expect(assigns(:feedback).user_id).to eql nil
        expect(assigns(:feedback).conversation_id).to eql nil
        expect(assigns(:feedback).consultant_id).to eql @sales.id
      end

      it "is available for customer" do
        expect(@conversation.lifecycle.can_feedback? @user).to be
      end
    end


    describe "GET :suggestions" do
      before :each do
        @first_product = create(:product)
        @second_product = create(:second_product)
        create(:suggestion, product_id:  @first_product.id,
                            conversation_id: @conversation.id)
        create(:suggestion, product_id:  @second_product.id,
                            conversation_id: @conversation.id)
      end

      it "reads the conversation" do
        get :suggestions, id: @conversation.id
        expect(assigns(:conversation)).to eql @conversation
      end

      it "reads the products" do
        get :suggestions, id: @conversation.id
        expect(assigns(:products)).to match_array([@first_product, @second_product])
      end
    end


    describe "POST #typing_customer" do
      it "publishes to conversations" do
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/conversations/"+ @conversation.id.to_s,
                                                        type: "typing_customer",
                                                        message: "my message")
        xhr :post, :typing_customer, id: @conversation.id,
                                     message: "my message"
      end

      it "renders nothing for xhr request" do
        xhr :post, :typing_customer, id: @conversation.id,
                   message: "my message"
        expect(response.body).to eql("")
      end
    end


    describe "GET #close" do
      it "creates a message" do
        xhr :get, :close, id: @conversation.id
        expect(assigns(:message).sender_id).to eql User::ROBOT.id
        expect(assigns(:message).reciever_id).to eql @sales.id
        expect(assigns(:message).conversation_id).to eql @conversation.id
        expect(assigns(:message).content).to eql "The Customer has left the conversation."
      end

      it "publishes to conversation" do
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/conversations/"+ @conversation.id.to_s,
                                                       type: "messages")
        xhr :get, :close, id: @conversation.id
      end

      it "renders nothing for xhr request" do
        xhr :get, :close, id: @conversation.id
        expect(response.body).to eql("")
      end
    end
  end
end