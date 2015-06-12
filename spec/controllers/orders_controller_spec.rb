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
    @newer_gtc = create(:newer_gtc)

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


    describe "PUT #do_place" do
      before :each do
        @user.update(gtc_version_of: @newer_gtc.version_of)
      end

      it "loads the order" do
        put :do_place, id: @basket.id
        expect(assigns(:order)).to eql @basket
      end

      context "success for mesonic push" do
        before :each do
          allow(Rails).to receive(:env) {"production"}
          expect_any_instance_of(User).to receive(:update_erp_account_nr)
          expect_any_instance_of(Order).to receive(:push_to_mesonic) {true}
        end

        it "updates mesonic erp account nr and pushes to mesonic, if enabled" do
          put :do_place, id: @basket.id
        end

        it "renders confirm" do
          put :do_place, id: @basket.id
          expect(response.body).to render_template :confirm
        end

        it "sets the flash messages" do
          put :do_place, id: @basket.id
          expect(flash[:notice]).to eql nil
          expect(flash[:success]).to eql "Your order is transmitted and will be processed shortly."
        end
      end

      context  "failure for mesonic push" do
        before :each do
          allow(Rails).to receive(:env) {"production"}
          expect_any_instance_of(User).to receive(:update_erp_account_nr)
          expect_any_instance_of(Order).to receive(:push_to_mesonic) {false}
        end

        it "trues to mesonic erp account nr and pushes to mesonic, if enabled" do
          put :do_place, id: @basket.id
        end

        it "renders confirm" do
          put :do_place, id: @basket.id
          expect(response.body).to render_template :error
        end

        it "sets the flash messages" do
          put :do_place, id: @basket.id
          expect(flash[:notice]).to eql nil
          expect(flash[:error]).to eql "Your order could not be processed. We will analyze the problem shortly."
        end
      end
    end


    describe "PUT #do_pay" do
      before :each do
        @user.update(gtc_version_of: @newer_gtc.version_of)
        @basket.update(billing_method: "e_payment")
      end

      it "loads the order" do
        put :do_place, id: @basket.id
        expect(assigns(:order)).to eql @basket
      end

      context "successful payment" do
        before :each do
          expect_any_instance_of(Order).to receive(:pay) { double(Struct, body: {select_payment_response: {location: users_path }})}
        end

        it "triggers payment, if enabled" do
          put :do_pay, id: @basket.id
        end

        it "redirects to location in select payment response / response" do
          put :do_pay, id: @basket.id
          expect(response.body).to redirect_to users_path
        end
      end

      context "failed payment" do
        before :each do
          expect_any_instance_of(Order).to receive(:pay) { double(Struct, body: { select_payment_response: { location: nil,
                                                                                                             err_text: "some error text" }})}
        end

        it "triggers payment, if enabled" do
          put :do_pay, id: @basket.id
        end

        it "renders show" do
          put :do_pay, id: @basket.id
          expect(response.body).to render_template :show
        end

        it "sets the flash messages" do
          put :do_pay, id: @basket.id
          expect(flash[:notice]).to eql nil
          expect(flash[:error]).to eql "some error text"
        end
      end
    end
  end
end