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
      expect(response.body).to redirect_to "http://test.host/switch"
    end

    it "is available as post" do
      post :login, login: "john.doe@informatom.com",
                   password: "secret123"
      expect(response.body).to redirect_to "http://test.host/switch"
    end

    it "logs the user out, if login comes from front" do
      session[:last_user] = 1

      expect(controller).to receive(:logout)
      post :login, login: "john.doe@informatom.com",
                   password: "secret123",
                   fromfront: "true"
    end

    it "logs the user in" do
      session[:last_user] = 1

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
        session[:last_user] = 1

        expect_any_instance_of(User).to receive(:sync_agb_with_basket)
        post :login, login: "john.doe@informatom.com",
                     password: "secret123"
      end
    end
  end


  describe "PUT #login_via_email" do
    context "state: active" do
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

      it "generates a lifecycle key" do
        get :login_via_email, id: @user.id,
                              key: @key
        @user.reload
        expect(assigns(:current_user).lifecycle.key).to eql @user.lifecycle.key
      end

      it "redirects to home page" do
        get :login_via_email, id: @user.id,
                              key: @key
        expect(response.body).to redirect_to "http://test.host"
      end

      it "copies over an existing basket" do
        @customer = create(:dummy_customer)
        @basket = @customer.basket
        create(:lineitem, order_id: @basket.id, user_id: @customer.id)
        session[:last_user] = @customer.id
        create(:constant_shipping_cost)

        get :login_via_email, id: @user.id,
                              key: @key
        expect(assigns(:current_user).basket.id).to eql @basket.id
      end

      it "syncs agbs" do
        @newer_gtc = create(:newer_gtc)
        @customer = create(:dummy_customer)
        @basket = @customer.basket
        @basket.update(gtc_version_of: Gtc.current)
        create(:lineitem, order_id: @basket.id, user_id: @customer.id)
        session[:last_user] = @customer.id
        create(:constant_shipping_cost)

        @user_basket = @user.basket
        get :login_via_email, id: @user.id,
                              key: @key
        expect(assigns(:current_user).gtc_version_of).to eql Gtc.current
      end
    end


    context "state: inactive" do
      before :each do
        @user = create(:user, state: "inactive")
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

      it "generates a lifecycle key" do
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

      it "copies over an existing basket" do
        @customer = create(:dummy_customer)
        @basket = @customer.basket
        create(:lineitem, order_id: @basket.id, user_id: @customer.id)
        session[:last_user] = @customer.id
        create(:constant_shipping_cost)

        get :login_via_email, id: @user.id,
                              key: @key
        expect(assigns(:current_user).basket.id).to eql @basket.id
      end

      it "syncs agbs" do
        @newer_gtc = create(:newer_gtc)
        @customer = create(:dummy_customer)
        @basket = @customer.basket
        @basket.update(gtc_version_of: Gtc.current)
        create(:lineitem, order_id: @basket.id, user_id: @customer.id)
        session[:last_user] = @customer.id
        create(:constant_shipping_cost)

        @user_basket = @user.basket
        get :login_via_email, id: @user.id,
                              key: @key
        expect(assigns(:current_user).gtc_version_of).to eql Gtc.current
      end
    end
  end


  describe "GET #logout" do
    before :each do
      act_as_user
      @user.update(logged_in: true)
      @user.basket
    end

    it "deletes an obsolete basket" do
      @basket_id = @user.basket.id
      get :logout
      expect(Order.where(id: @basket_id)).to be_empty
    end

    it "sets logged_in to false" do
      get :logout
      @user.reload
      expect(@user.logged_in).to eql false
    end

    it "calls hobo_logout" do
      get :logout
      expect(response.body).to redirect_to "http://test.host"
    end
  end


  describe "GET #switch" do
    before :each do
      act_as_user
      @user.basket
    end

    it "logs out the current_user" do
      get :switch
      @user.reload
      expect(@user.logged_in).to eql false
    end

    it "deletes an obsolete basket" do
      @basket_id = @user.basket.id
      get :switch
      expect(Order.where(id: @basket_id)).to be_empty
    end

    it "redirects to user login" do
      get :switch
      expect(response.body).to redirect_to user_login_path
    end

    it "sets last_user in session" do
      get :switch
      expect(session[:last_user]).to eql @user.id
    end
  end


  describe "POST #__email_login" do
    before :each do
      @user = create(:user)
    end

    it "finds the user" do
      post :request_email_login, email_address: "john.doe@informatom.com"
      expect(assigns(:user)).to eql @user
    end

    it "generates a lifecycle key" do
      post :request_email_login, email_address: "john.doe@informatom.com"
      @user.reload
      expect(Time.now - @user.key_timestamp < 3).to be true # let's say 3 seconds is enough...
    end

    it "sends an email to the user" do
      expect(UserMailer).to receive_message_chain(:login_link, :deliver)
      post :request_email_login, email_address: "john.doe@informatom.com"
    end
  end


  describe "PUT #do_activate" do
    before :each do
      act_as_user
      @user = create(:user, state: "inactive")
      @key = @user.lifecycle.generate_key
      @user.save
    end

    it "sets the flash notice" do
      put :do_activate, id: @user.id, key: @key
      expect(flash[:notice]).to eql "Your e-mail address was confirmed successfully and your account has been activated. You can close this tab now."
    end

    it "redirects to show user" do
      put :do_activate, id: @user.id, key: @key
      expect(response.body).to redirect_to user_path(@user)
    end

    it "is available for inactive user" do
      @user.lifecycle.provided_key = @key
      expect(@user.lifecycle.can_activate?(@user)).to be
    end

    it "is available for guest user" do
      @guest = create(:guest_user)
      @guest.lifecycle.generate_key
      @guest.save
      @guest.lifecycle.provided_key = @guest.lifecycle.key
      expect(@guest.lifecycle.can_activate?(@guest)).to be
    end
  end


  describe "GET #accept_gtc" do
    before :each do
      act_as_user
      @user = create(:user, state: "active")
      @newer_gtc = create(:newer_gtc)
      @older_gtc = create(:older_gtc)
    end

    it "finds the current GTC" do
      get :accept_gtc, id: @user.id
      expect(assigns(:current_gtc)).to eql @newer_gtc
    end

    it "sets the order id" do
      get :accept_gtc, id: @user.id,
                       order_id: 17
      expect(assigns(:user).order_id).to eql "17"
    end

    it "unsets user confirmation" do
      get :accept_gtc, id: @user.id
      expect(assigns(:user).confirmation).to eql false
    end


    context "user is active" do
      it "is available for active if gtc acceted is not current" do
        @user.update(gtc_version_of: Gtc.current,
                     gtc_confirmed_at: Time.now())
        expect(@user.lifecycle.can_accept_gtc? @user).to be false
      end

      it "is not available for active if gtc acceted is current" do
        expect(@user.lifecycle.can_accept_gtc? @user).to be
      end
    end


    context "user is guest" do
      it "is not available for guest" do
        @guest = create(:guest_user)
        expect(@guest.lifecycle.can_accept_gtc? @guest).to be false
      end
    end
  end


  describe "PUT #do_accept_gtc" do
    before :each do
      act_as_user
      @user = create(:user, state: "active")
      @newer_gtc = create(:newer_gtc)
      @older_gtc = create(:older_gtc)
      @basket = create(:basket, user_id: @user.id)
    end

    it "derives order from param order_id" do
      put :do_accept_gtc, id: @user.id,
                          order_id: 17
      expect(assigns(:order_id)).to eql "17"
    end

    it "derives order from param user >= order_id" do
      put :do_accept_gtc, id: @user.id,
                         user: { order_id: 17 }
      expect(assigns(:order_id)).to eql "17"
    end

    context "confirmation not checked" do
      it "sets flash error" do
        put :do_accept_gtc, id: @user.id,
                            order_id: 17
        expect(flash[:error]).to eql "You have to accept the General Terms and Conditions (GTCs), to continue with the order process!"
      end

      it "redirects to accept gtc" do
        put :do_accept_gtc, id: @user.id,
                            order_id: 17
        expect(response.body).to redirect_to accept_gtc_user_path(order_id: 17)
      end
    end

    context "confirmation checked" do
      it "redirects to order" do
        put :do_accept_gtc, id: @user.id,
                            order_id: @basket.id,
                            user: { confirmation: 1 }
        expect(response.body).to redirect_to order_path(id: @basket.id)
      end

      it "updates the confirmation data to the current user" do
        put :do_accept_gtc, id: @user.id,
                            order_id: @basket.id,
                            user: { confirmation: 1 }
        @user.reload
        expect(@user.gtc_version_of).to eql Date.new(2014,01,23)
        expect(Time.now - @user.gtc_confirmed_at < 3).to eql true
      end

      it "updates the confirmation data to the current basket" do
        put :do_accept_gtc, id: @user.id,
                            order_id: @basket.id,
                            user: { confirmation: 1 }
        @basket.reload
        expect(@basket.gtc_version_of).to eql Date.new(2014,01,23)
        expect(Time.now - @basket.gtc_confirmed_at < 3).to eql true
      end
    end
  end


  describe "POST #upgrade" do
    before :each do
      act_as_user
      @user = create(:user, state: "guest")
      @basket = @user.basket
    end

    it "updates the user parameters" do
      post :upgrade, id: @user.id,
                     user: { email_address: "another.email@mercator.informatom.com" },
                     page_path: order_path(id: @basket.id)
      expect(assigns(:user).email_address).to eql "another.email@mercator.informatom.com"
    end


    it "sends the activation email" do
      expect(UserMailer).to receive_message_chain(:activation, :deliver)
      post :upgrade, id: @user.id,
                     user: { email_address: "another.email@mercator.informatom.com" },
                     page_path: order_path(id: @basket.id)
    end

    it "sets the flash notice" do
      post :upgrade, id: @user.id,
                     user: { email_address: "another.email@mercator.informatom.com" },
                     page_path: order_path(id: @basket.id)
      expect(flash[:notice]).to eql "Please klick an the confirmation link in the e-mail message sent to you and refresh this page afterwards."
    end

    it "sets the flash error, if user cannot be updated" do
      allow_any_instance_of(User).to receive(:update_attributes).and_return(false)
      post :upgrade, id: @user.id,
                     user: { email_address: "another.email@mercator.informatom.com" },
                     page_path: order_path(id: @basket.id)
      expect(flash[:error]).to eql "The data you provided could not be saved. Is the e-mail address correct or maybe already registered?"
    end

    it "generates a lifecycle key" do
      post :upgrade, id: @user.id,
                     user: { email_address: "another.email@mercator.informatom.com" },
                     page_path: order_path(id: @basket.id)
      @user.reload
      expect(Time.now - @user.key_timestamp < 3).to be true # let's say 3 seconds is enough...
    end


    it "redirects to page path" do
      post :upgrade, id: @user.id,
                     page_path: order_path(id: @basket.id)
      expect(response.body).to redirect_to order_path(id: @basket.id)
    end
  end


  describe "PUT #do_request_password_reset" do
    before :each do
      act_as_user
    end

    it "is available for inactive user" do
      @user = create(:user, state: "inactive")
      expect(@user.lifecycle.can_request_password_reset?(@user)).to be
    end

    it "sends activation email for inactive user" do
      @user = create(:user, state: "inactive")
      expect(UserMailer).to receive_message_chain(:forgot_password, :deliver)
      @user.lifecycle.request_password_reset!(@user)
    end

    it "is available for active user" do
      @user = create(:user, state: "active")
      expect(@user.lifecycle.can_request_password_reset?(@user)).to be
    end

    it "sends activation email for active user" do
      @user = create(:user, state: "active")
      expect(UserMailer).to receive_message_chain(:forgot_password, :deliver)
      @user.lifecycle.request_password_reset!(@user)
    end

    it "is available for guest user" do
      @user = create(:user, state: "guest")
      expect(@user.lifecycle.can_request_password_reset?(@user)).to be
    end

    it "sends activation email for guest user" do
      @user = create(:user, state: "guest")
      expect(UserMailer).to receive_message_chain(:forgot_password, :deliver)
      @user.lifecycle.request_password_reset!(@user)
    end
  end


  describe "GET #reset_password" do
    before :each do
      act_as_user
    end

    context "active user" do
      it "is available for active user" do
        @user = create(:user, state: "active")
        @user.lifecycle.provided_key = @user.lifecycle.generate_key
        expect(@user.lifecycle.can_reset_password?(@user)).to be
      end

      it "is available without key for active user without password set" do
        @user = create(:user, state: "active",
                              password: nil)
        expect(@user.lifecycle.can_reset_password?(@user)).to be
      end
    end

    context "inactive user" do
      it "is available for inactive user" do
        @user = create(:user, state: "inactive", password: nil)
        @user.lifecycle.provided_key = @user.lifecycle.generate_key
        expect(@user.lifecycle.can_reset_password?(@user)).to be
      end

      it "is available without key for inactive user without password set" do
        @user = create(:user, state: "inactive",
                              password: nil)
        expect(@user.lifecycle.can_reset_password?(@user)).to be
      end
    end
  end


  describe "login_via_email"  do
    before :each do
      act_as_user
    end

    context "state: active" do
      it "is available for active user" do
        @user = create(:user, state: "active")
        @user.lifecycle.provided_key = @user.lifecycle.generate_key
        expect(@user.lifecycle.can_login_via_email?(@user)).to be
      end

      it "is not available for active user for invalid key" do
        @user = create(:user, state: "active")
        @user.lifecycle.provided_key = @user.lifecycle.generate_key + "wrong"
        expect(@user.lifecycle.can_login_via_email?(@user)).to be false
      end
    end

    context "state: inactive" do
      it "is available for inactive user" do
        @user = create(:user, state: "inactive")
        @user.lifecycle.provided_key = @user.lifecycle.generate_key
        expect(@user.lifecycle.can_login_via_email?(@user)).to be
      end

      it "is not available for inactive user for invalid key" do
        @user = create(:user, state: "inactive")
        @user.lifecycle.provided_key = @user.lifecycle.generate_key + "wrong"
        expect(@user.lifecycle.can_login_via_email?(@user)).to be false
      end
    end
  end


  describe "PUT #resend_email_confirmation" do
    before :each do
      act_as_user
    end

    it "is available for inactive user" do
      @user = create(:user, state: "inactive")
      expect(@user.lifecycle.can_resend_email_confirmation?(@user)).to be
    end

    it "sends activation email for inactive user" do
      @user = create(:user, state: "inactive")
      expect(UserMailer).to receive_message_chain(:activation, :deliver)
      put :do_resend_email_confirmation, id: @user.id
    end

    it "is available for guest user" do
      @user = create(:user, state: "guest")
      expect(@user.lifecycle.can_request_password_reset?(@user)).to be
    end

    it "sends activation email for guest user" do
      @user = create(:user, state: "guest")
      expect(UserMailer).to receive_message_chain(:activation, :deliver)
      put :do_resend_email_confirmation, id: @user.id
    end

    it "redirects to current basket" do
      @user = create(:user, state: "inactive")
      put :do_resend_email_confirmation, id: @user.id
      expect(response.body).to redirect_to order_path(@user.basket)
    end
  end
end
