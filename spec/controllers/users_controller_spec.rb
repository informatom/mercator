require 'spec_helper'

describe UsersController, :type => :controller do
  before :each do
    no_redirects
  end


  describe 'GET #show' do
    it "renders the :show template" do
      act_as_user
      get :show, id: @user
      expect(response).to render_template :show
    end
  end


  describe 'GET #edit' do
    it "renders the :show template" do
      act_as_user
      get :edit, id: @user
      expect(response).to render_template :edit
    end
  end


  describe 'PATCH #update' do
    it "with correct data it redirects to #show" do
      act_as_user
      patch :update, id: @user.id, user: { email_address: "new.address@mercator.informatom.com"}
      expect(response.body).to redirect_to user_path(assigns(:user))
    end
  end


  describe 'GET or POST #login', focus: true do
    before :each do
      @user = create(:user, state: "active")
    end

    it "is available as get" do
      get :login
      expect(response.body).to render_template :login
    end

    it "is available as post" do
      post :login, login: "john.doe@informatom.com",
                   password: "secret123"
      expect(response.body).to redirect_to "http://test.host"
    end

    it "vogs the user out, if login comes from front" do
      expect(controller).to receive(:logout)
      post :login, login: "john.doe@informatom.com",
                   password: "secret123",
                   fromfront: "true"
    end

    it "logs the user in" do
      post :login, login: "john.doe@informatom.com",
                   password: "secret123"
      @user.reload
      expect(@user.logged_in).to be true
    end


    context "there was a last user with session, basket and conversation" do
      before :each do
        @guest = create(:guest_user)
        @sales = create(:sales)
        @last_basket = @guest.basket
        @last_basket_item = create(:lineitem, order_id: @last_basket.id,
                                              user_id: @guest.id)
        @last_conversation = create(:conversation, customer_id: @guest.id,
                                                   consultant_id: @sales.id)
      end

      it "derives the last user from the session" do
        session[:last_user] = @guest.id
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        expect(assigns(:last_user)).to eql @guest
      end
    end
  end
end