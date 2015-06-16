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


  describe 'GET or POST #login' do
    before :each do
      create(:constant_shipping_cost)
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
        session[:last_user] = @guest.id
      end

      it "derives the last user from the session" do
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        expect(assigns(:last_user)).to eql @guest
      end

      it "derives the last basket from the session" do
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        expect(assigns(:last_basket)).to eql @last_basket
      end

      it "assigns the existing conversation to the user" do
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        @last_conversation.reload
        expect(@last_conversation.customer_id).to eql @user.id
      end

      it "deletes the last_basket, if obsolete" do
        @last_basket_item.delete
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        expect(Order.where(id: @last_basket.id)).to be_empty
      end

      it "parkes the current basket, if a last basket exists and is not obsolete" do
        create(:lineitem, order_id: @user.basket.id,
                          user_id: @user.id,
                          product_number: "my number",
                          product_id: nil)
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        expect(Order.where(state: "parked").count).to be 1
      end

      it "deletes the current basket, if a last basket exists and is obsolete" do
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        expect(Order.where(state: "parked").count).to be 0
      end

      it "assigns the last basket as the current basket"  do
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        expect(@user.basket.id).to eql @last_basket.id
      end

      it "assigns the lineitems in the last basket to the current user" do
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        @last_basket_item.reload
        expect(@last_basket_item.user_id).to eql @user.id
      end
    end


    context "there is no last user" do
      it "keep the basket untouched" do
        @basket_id = @user.basket.id
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
        @user.basket.reload
        expect(@user.basket.id).to eql @basket_id
      end

      it "tries to sync agb with basket" do
        expect_any_instance_of(User).to receive(:sync_agb_with_basket)
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
      end
    end
  end


  describe "PUT #login_via_email"do
    before :each do
      @user = create(:user, state: "active")
      @key = @user.lifecycle.generate_key
      @user.save
    end

    it "finds the current_user" do
      get :login_via_email, id: @user.id,
                            key: @key
      expect(assigns(:current_user).id).to eql @user.id
    end

    it "creats cookie" do
      expect(controller).to receive(:create_auth_cookie)
      get :login_via_email, id: @user.id,
                            key: @key
    end

    it "generates a lifecycle key", focus: true do
      get :login_via_email, id: @user.id,
                            key: @key
      @user.reload
      expect(assigns(:current_user).lifecycle.key).to eql @user.lifecycle.key
    end

    it "redirects to hemo page" do
      get :login_via_email, id: @user.id,
                            key: @key
      expect(response.body).to redirect_to "http://test.host"
    end
  end
end