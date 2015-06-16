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

    request.env['HTTP_REFERER'] = categories_path
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
    describe "PUT #do_from_offer" do
      it "is available" do
        expect(Order::Lifecycle.can_from_offer? @user).to be
      end
    end


    describe "PUT #do_archive_parked_basket" do
      it "sets flash messages" do
        put :do_archive_parked_basket, id: @parked_basket.id
        expect(flash[:notice]).to eql nil
        expect(flash[:success]).to eql "The parked basket was archived."
      end

      it "redirects to" do
        put :do_archive_parked_basket, id: @parked_basket.id
        expect(response).to redirect_to categories_path
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
          expect_any_instance_of(Order).to receive(:pay) { double(Struct, body: {select_payment_response: {location: categories_path }})}
        end

        it "triggers payment, if enabled" do
          put :do_pay, id: @basket.id
        end

        it "redirects to location in select payment response / response" do
          put :do_pay, id: @basket.id
          expect(response.body).to redirect_to categories_path
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


    describe "PUT #do_cash_payment" do
      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id)
          expect(@order.lifecycle.can_cash_payment? @user).to be
        end

        it "sets cash_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id)
          @order.lifecycle.cash_payment!(@user)
          expect(@order.billing_method).to eql "cash_payment"
        end

        it "it is not avaiilable for non pickup_shipmant" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "parcel_service_shipment",
                                  user_id: @user.id)
          put :do_cash_payment, id: @order.id
          expect(response).to have_http_status(403)
        end

        it "it is not available for cash_payment" do
          @order = create(:order, billing_method: "cash_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id)
          put :do_cash_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_cash_payment? @user).to be
        end

        it "sets cash_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          @order.lifecycle.cash_payment!(@user)
          expect(@order.billing_method).to eql "cash_payment"
        end

        it "it is not avaiilable for non pickup_shipmant" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "parcel_service_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          put :do_cash_payment, id: @order.id
          expect(response).to have_http_status(403)
        end

        it "it is not available for cash_payment" do
          @order = create(:order, billing_method: "cash_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          put :do_cash_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is payment_failed" do
        it "is available for payment_failed" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_cash_payment? @user).to be
        end

        it "sets cash_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          @order.lifecycle.cash_payment!(@user)
          expect(@order.billing_method).to eql "cash_payment"
        end

        it "it is not avaiilable for non pickup_shipmant" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "parcel_service_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          put :do_cash_payment, id: @order.id
          expect(response).to have_http_status(403)
        end

        it "it is not available for cash_payment" do
          @order = create(:order, billing_method: "cash_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          put :do_cash_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end
    end


    describe "PUT #do_atm_payment" do
      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id)
          expect(@order.lifecycle.can_atm_payment? @user).to be
        end

        it "sets atm_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id)
          @order.lifecycle.atm_payment!(@user)
          expect(@order.billing_method).to eql "atm_payment"
        end

        it "it is not avaiilable for non pickup_shipmant" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "parcel_service_shipment",
                                  user_id: @user.id)
          put :do_atm_payment, id: @order.id
          expect(response).to have_http_status(403)
        end

        it "it is not available for atm_payment" do
          @order = create(:order, billing_method: "atm_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id)
          put :do_atm_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_atm_payment? @user).to be
        end

        it "sets atm_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          @order.lifecycle.atm_payment!(@user)
          expect(@order.billing_method).to eql "atm_payment"
        end

        it "it is not avaiilable for non pickup_shipmant" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "parcel_service_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          put :do_atm_payment, id: @order.id
          expect(response).to have_http_status(403)
        end

        it "it is not available for atm_payment" do
          @order = create(:order, billing_method: "atm_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          put :do_atm_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is payment_failed" do
        it "is available for payment_failed" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_atm_payment? @user).to be
        end

        it "sets atm_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          @order.lifecycle.atm_payment!(@user)
          expect(@order.billing_method).to eql "atm_payment"
        end

        it "it is not avaiilable for non pickup_shipmant" do
          @order = create(:order, billing_method: "e_payment",
                                  shipping_method: "parcel_service_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          put :do_atm_payment, id: @order.id
          expect(response).to have_http_status(403)
        end

        it "it is not available for atm_payment" do
          @order = create(:order, billing_method: "atm_payment",
                                  shipping_method: "pickup_shipment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          put :do_atm_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end
    end


    describe "PUT #do_pre_payment" do
      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id)
          expect(@order.lifecycle.can_pre_payment? @user).to be
        end

        it "sets pre_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id)
          @order.lifecycle.pre_payment!(@user)
          expect(@order.billing_method).to eql "pre_payment"
        end

        it "it is not available for pre_payment" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id)
          put :do_pre_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_pre_payment? @user).to be
        end

        it "sets pre_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          @order.lifecycle.pre_payment!(@user)
          expect(@order.billing_method).to eql "pre_payment"
        end

        it "it is not available for pre_payment" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          put :do_pre_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is payment_failed" do
        it "is available for payment_failed" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_pre_payment? @user).to be
        end

        it "sets pre_payment as billing_method" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          @order.lifecycle.pre_payment!(@user)
          expect(@order.billing_method).to eql "pre_payment"
        end

        it "it is not available for pre_payment" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          put :do_pre_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end
    end


    describe "PUT #do_e_payment" do
      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id)
          expect(@order.lifecycle.can_e_payment? @user).to be
        end

        it "sets e_payment as billing_method" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id)
          @order.lifecycle.e_payment!(@user)
          expect(@order.billing_method).to eql "e_payment"
        end

        it "it is not available for e_payment" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id)
          put :do_e_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_e_payment? @user).to be
        end

        it "sets e_payment as billing_method" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          @order.lifecycle.e_payment!(@user)
          expect(@order.billing_method).to eql "e_payment"
        end

        it "it is not available for e_payment" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id,
                                  state: "accepted_offer")
          put :do_e_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end


      context "order is payment_failed" do
        it "is available for payment_failed" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_e_payment? @user).to be
        end

        it "sets e_payment as billing_method" do
          @order = create(:order, billing_method: "pre_payment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          @order.lifecycle.e_payment!(@user)
          expect(@order.billing_method).to eql "e_payment"
        end

        it "it is not available for e_payment" do
          @order = create(:order, billing_method: "e_payment",
                                  user_id: @user.id,
                                  state: "payment_failed")
          put :do_e_payment, id: @order.id
          expect(response).to have_http_status(403)
        end
      end
    end


    describe "PUT #do_check" do
      before :each do
        @older_gtc = create(:older_gtc)
        @current_gtc = create(:newer_gtc)
        @user.update(gtc_version_of: @current_gtc.version_of)
      end


      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, user_id: @user.id)
          expect(@order.lifecycle.can_check? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id)
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil)
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end

        it "is not available if shipping_method is not filled" do
          @order = create(:order, user_id: @user.id,
                                  shipping_method: nil)
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_check? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer")
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end

        it "is not available if shipping_method is not filled" do
          @order = create(:order, user_id: @user.id,
                                  shipping_method: nil,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end
      end


      context "order is in_payment" do
        it "is available for in_payment" do
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          expect(@order.lifecycle.can_check? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @user.update(gtc_version_of: @older_gtc.version_of)
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end

        it "is not available if shipping_method is not filled" do
          @order = create(:order, user_id: @user.id,
                                  shipping_method: nil,
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_check? @user).to be_falsy
        end
      end
    end


    describe "PUT #do_place" do
      before :each do
        @older_gtc = create(:older_gtc)
        @current_gtc = create(:newer_gtc)
        @user.update(gtc_version_of: @current_gtc.version_of)
      end


      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, user_id: @user.id)
          expect(@order.lifecycle.can_place? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id)
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_place? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil)
          expect(@order.lifecycle.can_place? @user).to be_falsy
        end

        it "is not available if billing method is e-payment" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment")
          expect(@order.lifecycle.can_place? @user).to be_falsy
        end

        it "changes the state to ordered" do
          @order = create(:order, user_id: @user.id)
          @user.update(gtc_version_of: @current_gtc.version_of)
          @order.lifecycle.place!(@user)
          expect(@order.state).to eql "ordered"
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, user_id: @user.id,
                                  state:"accepted_offer")
          expect(@order.lifecycle.can_place? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id,
                                  state:"accepted_offer")
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_place? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil,
                                  state:"accepted_offer")
          expect(@order.lifecycle.can_place? @user).to be_falsy
        end

        it "is not available if billing method is e-payment" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state:"accepted_offer")
          expect(@order.lifecycle.can_place? @user).to be_falsy
        end

        it "changes the state to ordered" do
          @order = create(:order, user_id: @user.id,
                           state:"accepted_offer")
          @user.update(gtc_version_of: @current_gtc.version_of)
          @order.lifecycle.place!(@user)
          expect(@order.state).to eql "ordered"
        end
      end
    end


    describe "PUT #do_pay" do
      before :each do
        @older_gtc = create(:older_gtc)
        @current_gtc = create(:newer_gtc)
        @user.update(gtc_version_of: @current_gtc.version_of)
      end


      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment")
          expect(@order.lifecycle.can_pay? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment")
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil,
                                  billing_method: "e_payment")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing method is not e_payment" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "pre_payment")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "changes the state to ordered" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment")
          @user.update(gtc_version_of: @current_gtc.version_of)
          @order.lifecycle.pay!(@user)
          expect(@order.state).to eql "in_payment"
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_pay? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "accepted_offer")
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil,
                                  billing_method: "e_payment",
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing method is not e_payment" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "pre_payment",
                                  state: "accepted_offer")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "changes the state to ordered" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "accepted_offer")
          @user.update(gtc_version_of: @current_gtc.version_of)
          @order.lifecycle.pay!(@user)
          expect(@order.state).to eql "in_payment"
        end
      end


      context "order is in_payment" do
        it "is available for in_payment" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "in_payment")
          expect(@order.lifecycle.can_pay? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "in_payment")
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil,
                                  billing_method: "e_payment",
                                  state: "in_payment")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing method is not e_payment" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "pre_payment",
                                  state: "in_payment")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "changes the state to ordered" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "in_payment")
          @user.update(gtc_version_of: @current_gtc.version_of)
          @order.lifecycle.pay!(@user)
          expect(@order.state).to eql "in_payment"
        end
      end


      context "order is payment_failed" do
        it "is available for payment_failed" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "payment_failed")
          expect(@order.lifecycle.can_pay? @user).to be
        end

        it "is not available if gtc accepted is not current" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "payment_failed")
          @user.update(gtc_version_of: @older_gtc.version_of)
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing address is not filled" do
          @order = create(:order, user_id: @user.id,
                                  billing_city: nil,
                                  billing_method: "e_payment",
                                  state: "payment_failed")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "is not available if billing method is not e_payment" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "pre_payment",
                                  state: "payment_failed")
          expect(@order.lifecycle.can_pay? @user).to be_falsy
        end

        it "changes the state to ordered" do
          @order = create(:order, user_id: @user.id,
                                  billing_method: "e_payment",
                                  state: "payment_failed")
          @user.update(gtc_version_of: @current_gtc.version_of)
          @order.lifecycle.pay!(@user)
          expect(@order.state).to eql "in_payment"
        end
      end
    end


    describe "PUT #do_failing_payment" do
      before :each do
        @mpay24_user = create(:mpay24_user)
      end

      context "order is in_payment" do
        it "is available for mpay24_user" do
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          expect(@order.lifecycle.can_failing_payment? @mpay24_user).to be
        end

        it "is not available for user" do
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          expect(@order.lifecycle.can_failing_payment? @user).to be_falsy
        end

        it "changes the status to payment_failed" do
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          @order.lifecycle.failing_payment!(@mpay24_user)
          expect(@order.state).to eql "payment_failed"
        end
      end


      context "order is payment_failed" do
        it "is available for mpay24_user" do
          @order = create(:order, user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_failing_payment? @mpay24_user).to be
        end

        it "is not available for user" do
          @order = create(:order, user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_failing_payment? @user).to be_falsy
        end

        it "changes the status to payment_failed" do
          @order = create(:order, user_id: @user.id,
                                  state: "payment_failed")
          @order.lifecycle.failing_payment!(@mpay24_user)
          expect(@order.state).to eql "payment_failed"
        end
      end


      context "order is paid" do
        it "is available for mpay24_user" do
          @order = create(:order, user_id: @user.id,
                                  state: "paid")
          expect(@order.lifecycle.can_failing_payment? @mpay24_user).to be
        end

        it "is not available for user" do
          @order = create(:order, user_id: @user.id,
                                  state: "paid")
          expect(@order.lifecycle.can_failing_payment? @user).to be_falsy
        end

        it "changes the status to payment_failed" do
          @order = create(:order, user_id: @user.id,
                                  state: "paid")
          @order.lifecycle.failing_payment!(@mpay24_user)
          expect(@order.state).to eql "payment_failed"
        end
      end
    end


    describe "PUT #do_successful_payment" do
      before :each do
        @mpay24_user = create(:mpay24_user)
      end

      context "order is in_payment" do
        it "is available for mpay24_user" do
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          expect(@order.lifecycle.can_successful_payment? @mpay24_user).to be
        end

        it "is not available for user" do
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          expect(@order.lifecycle.can_successful_payment? @user).to be_falsy
        end

        it "changes the status to payment_failed" do
          @order = create(:order, user_id: @user.id,
                                  state: "in_payment")
          @order.lifecycle.successful_payment!(@mpay24_user)
          expect(@order.state).to eql "paid"
        end
      end


      context "order is payment_failed" do
        it "is available for mpay24_user" do
          @order = create(:order, user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_successful_payment? @mpay24_user).to be
        end

        it "is not available for user" do
          @order = create(:order, user_id: @user.id,
                                  state: "payment_failed")
          expect(@order.lifecycle.can_successful_payment? @user).to be_falsy
        end

        it "changes the status to payment_failed" do
          @order = create(:order, user_id: @user.id,
                                  state: "payment_failed")
          @order.lifecycle.successful_payment!(@mpay24_user)
          expect(@order.state).to eql "paid"
        end
      end


      context "order is paid" do
        it "is available for mpay24_user" do
          @order = create(:order, user_id: @user.id,
                                  state: "paid")
          expect(@order.lifecycle.can_successful_payment? @mpay24_user).to be
        end

        it "is not available for user" do
          @order = create(:order, user_id: @user.id,
                                  state: "paid")
          expect(@order.lifecycle.can_successful_payment? @user).to be_falsy
        end

        it "changes the status to payment_failed" do
          @order = create(:order, user_id: @user.id,
                                  state: "paid")
          @order.lifecycle.successful_payment!(@mpay24_user)
          expect(@order.state).to eql "paid"
        end
      end
    end


    describe "PUT #do_park" do
      it "is available for basket" do
        @order = create(:order, user_id: @user.id,
                                state: "basket")
        expect(@order.lifecycle.can_park? @user).to be
      end

      it "changes the status to parked" do
        @order = create(:order, user_id: @user.id,
                                state: "basket")
        @order.lifecycle.park!(@user)
        expect(@order.state).to eql "parked"
      end
    end


    describe "PUT #do_archive_parked_basket" do
      it "is available for parked basket" do
        @order = create(:order, user_id: @user.id,
                                state: "parked")
        expect(@order.lifecycle.can_archive_parked_basket? @user).to be
      end

      it "changes the status to parked" do
        @order = create(:order, user_id: @user.id,
                                state: "parked")
        @order.lifecycle.archive_parked_basket!(@user)
        expect(@order.state).to eql "archived_basket"
      end
    end


    describe "PUT #do_pickup_shipment" do
      before :each do
        @shipping_cost_article = create(:shipping_cost_article)
        @inventory_versandspesen = create(:inventory_with_two_prices, number: @shipping_cost_article.number,
                                                                      product_id: @shipping_cost_article.id)
      end

      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "parcel_service_shipment")
          expect(@order.lifecycle.can_pickup_shipment? @user).to be
        end

        it "updates the shipment method" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "parcel_service_shipment")
          @order.lifecycle.pickup_shipment!(@user)
          expect(@order.shipping_method).to eql "pickup_shipment"
        end

        it "deletes a shipping cost line" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "parcel_service_shipment")
          allow(@order).to receive(:acting_user) { @user }
          @order.add_shipment_costs
          expect { @order.lifecycle.pickup_shipment!(@user) }.to change {@order.lineitems.count}.by -1
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "parcel_service_shipment")
          expect(@order.lifecycle.can_pickup_shipment? @user).to be
        end

        it "updates the shipment method" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "parcel_service_shipment")
          @order.lifecycle.pickup_shipment!(@user)
          expect(@order.shipping_method).to eql "pickup_shipment"
        end

        it "deletes a shipping cost line" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "parcel_service_shipment")
          allow(@order).to receive(:acting_user) { @user }
          @order.add_shipment_costs
          expect { @order.lifecycle.pickup_shipment!(@user) }.to change {@order.lineitems.count}.by -1
        end
      end
    end


    describe "PUT #parcel_service_shipment" do
      before :each do
        @shipping_cost_article = create(:shipping_cost_article)
        @inventory_versandspesen = create(:inventory_with_two_prices, number: @shipping_cost_article.number,
                                                                      product_id: @shipping_cost_article.id)
      end

      context "order is basket" do
        it "is available for basket" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "pickup_shipment")
          expect(@order.lifecycle.can_parcel_service_shipment? @user).to be
        end

        it "updates the shipment method" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "pickup_shipment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.shipping_method).to eql "parcel_service_shipment"
        end

        it "adds a shipping cost line" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "pickup_shipment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.lineitems.find_by(product_number: @shipping_cost_article.number)).to be_a Lineitem
        end

        it "is not available for parcel service shipment" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "parcel_service_shipment")
          expect(@order.lifecycle.can_parcel_service_shipment? @user).to be false
        end

        it "is not available for not shippable product" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "pickup_shipment")
          @not_shippable_product = create(:product, number: "not shippable",
                                           not_shippable: true)
          create(:lineitem, order_id: @order.id,
                            product_id: @not_shippable_product.id)
          expect(@order.lifecycle.can_parcel_service_shipment? @user).to be false
        end

        it "updates the billing_method, if it was atm_payment" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "pickup_shipment",
                                  billing_method: "atm_payment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.billing_method).to be :e_payment
        end

        it "updates the billing_method, if it was cash_payment" do
          @order = create(:order, user_id: @user.id,
                                  state: "basket",
                                  shipping_method: "pickup_shipment",
                                  billing_method: "cash_payment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.billing_method).to be :e_payment
        end
      end


      context "order is accepted_offer" do
        it "is available for accepted_offer" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "pickup_shipment")
          expect(@order.lifecycle.can_parcel_service_shipment? @user).to be
        end

        it "updates the shipment method" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "pickup_shipment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.shipping_method).to eql "parcel_service_shipment"
        end

        it "adds a shipping cost line" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "pickup_shipment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.lineitems.find_by(product_number: @shipping_cost_article.number)).to be_a Lineitem
        end

        it "is not available for parcel service shipment" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "parcel_service_shipment")
          expect(@order.lifecycle.can_parcel_service_shipment? @user).to be false
        end

        it "is not available for not shippable product" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "pickup_shipment")
          @not_shippable_product = create(:product, number: "not shippable",
                                           not_shippable: true)
          create(:lineitem, order_id: @order.id,
                            product_id: @not_shippable_product.id)
          expect(@order.lifecycle.can_parcel_service_shipment? @user).to be false
        end

        it "updates the billing_method, if it was atm_payment" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "pickup_shipment",
                                  billing_method: "atm_payment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.billing_method).to be :e_payment
        end

        it "updates the billing_method, if it was cash_payment" do
          @order = create(:order, user_id: @user.id,
                                  state: "accepted_offer",
                                  shipping_method: "pickup_shipment",
                                  billing_method: "cash_payment")
          @order.lifecycle.parcel_service_shipment!(@user)
          expect(@order.billing_method).to be :e_payment
        end
      end
    end


    describe "PUT #do_delete_all_positions" do
      it "is available for basket" do
        @order = create(:order, user_id: @user.id,
                                state: "basket")
        @lineitem = create(:lineitem, order_id: @order.id,
                                      product_id: @product.id,
                                      user_id: @user.id)
        expect(@order.lifecycle.can_delete_all_positions? @user).to be
      end

      it "deletes all lineitems" do
        @order = create(:order, user_id: @user.id,
                                state: "basket")
        @lineitem = create(:lineitem, order_id: @order.id,
                                      product_id: @product.id,
                                      user_id: @user.id)
        @second_product = create(:second_product)
        @onother_lineitem = create(:lineitem, order_id: @order.id,
                                              product_id: @second_product.id,
                                              user_id: @user.id)

        expect {@order.lifecycle.delete_all_positions!(@user)}.to change {@order.lineitems.count}.by -2
      end

      it "is not available if there are no lineitems" do
        @order = create(:order, user_id: @user.id,
                                state: "basket")
        expect(@order.lifecycle.can_delete_all_positions? @user).to be false
      end
    end
  end
end