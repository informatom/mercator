require 'spec_helper'

describe OrdersController, :type => :controller do
  before :each do
    no_redirects and act_as_user

    @basket = create(:order, user_id: @user.id)
    @product = create(:product)
    @lineitem = create(:lineitem, order_id: @basket.id,
                                  user_id: @user.id,
                                  product_id: @product.id)

    create(:constant_shipping_cost)
    @parked_basket = create(:parked_basket, user_id: @user.id)
    create(:lineitem, order_id: @parked_basket.id,
                      user_id: @user.id,
                      product_id: @product.id)

    request.env['HTTP_REFERER'] = users_path
  end


  context "auto actions" do
    describe "GET #index_for_user" do
      it "renders index template" do
        get :index_for_user, user_id: @user.id
        expect(response.body).to render_template "orders/index_for_user"
      end
    end
  end


  describe "GET #show" do
    it "reads current gtc" do
      @older_gtc = create(:older_gtc)
      @newer_gtc = create(:newer_gtc)
      get :show, id: @basket.id
      expect(assigns(:current_gtc)).to eql @newer_gtc
    end

    it "reads the parked basket" do
      get :show, id: @basket.id
      expect(assigns(:parked_basket)).to eql @parked_basket
    end

    it "unset confirmation for current_user" do
      @user.update(confirmation: true)
      get :show, id: @basket.id
      expect(@user.confirmation).to eql false
    end
  end


  describe "POST #refresh" do
    it "loads the order" do
      xhr :post, :refresh, id: @basket.id, render: "whatever"
      expect(assigns(:order)).to eql @basket
    end
  end


  describe "POST #payment_status" do
    it "loads the order" do
      post :payment_status, id: @basket.id
      expect(assigns(:order)).to eql @basket
    end

    it "renders confirm" do
      post :payment_status, id: @basket.id
      expect(response.body).to render_template :confirm
    end
  end


  context "lifecycle actions" do
    describe "PUT #do_archive_parked_basket" do
      it "sets flash messages" do
        put :do_archive_parked_basket, id: @parked_basket.id
        expect(flash[:notice]).to eql nil
        expect(flash[:success]).to eql "The parked basket was archived."
      end

      it "redirects to" do
        put :do_archive_parked_basket, id: @parked_basket.id
        expect(response).to redirect_to users_path
      end
    end


    describe "PUT #do_place", focus: true do
      it "loads the order" do
        put :do_place, id: @basket.id
        expect(assigns(:order)).to eql @basket
      end


    end
  end
end