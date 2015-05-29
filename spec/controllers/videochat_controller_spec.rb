require 'spec_helper'

describe VideochatController, :type => :controller do

  before :each do
    no_redirects and act_as_user
  end


  describe "GET #show" do
    it "updates current user" do
      get :show
      expect(@user.waiting).to eql true
    end

    it "calls for chat partner" do
      expect(@user).to receive_message_chain(:delay, :call_for_chat_partner)
      get :show
    end

    it "sets the channel id" do
      get :show
      expect(assigns(:channel_id)).to be @user.id
    end
  end


  describe "GET #pickup" do
    before :each do
      @waiting_user = create(:user, waiting: true)
    end

    it "sets the channel id" do
      get :pickup, id: @waiting_user.id
      expect(assigns(:channel_id)).to be request.params[:id]
    end

    it "resets the waiting user" do
      get :pickup, id: @waiting_user.id
      @waiting_user.reload
      expect(@waiting_user.waiting).to eql false
    end

    it "renders show" do
      get :pickup, id: @waiting_user.id
      expect(response).to render_template :show
    end
  end
end