require 'spec_helper'

describe ConfirmationsController, :type => :controller do
  describe "GET #create" do
    before :each do
      no_redirects and act_as_mpay24
      @user = create(:user)
      @order = create(:order, state: "in_payment",
                              user_id: @user.id)
      @payment = create(:payment, order_id: @order.id)
      @request_params = { OPERATION: "CONFIRMATION",
                          TID: @payment.id,
                          STATUS: "BILLED",
                          PRICE: "101520",
                          CURRENCY: "EUR",
                          P_TYPE: "CC",
                          BRAND: "VISA",
                          MPAYTID: "1793508",
                          USER_FIELD: "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4f6bd0d1c98509",
                          ORDERDESC: "Warenkorb vom Mo, 9.Feb 15,  9:17",
                          CUSTOMER: "50",
                          CUSTOMER_EMAIL: "some.email@mecator.informatom.com",
                          LANGUAGE: "DE",
                          CUSTOMER_ID: "4711",
                          PROFILE_ID: "4811",
                          PROFILE_STATUS: "IGNORED",
                          FILTER_STATUS: "some status",
                          APPR_CODE: "-test-" }
    end

    it "raises error, if not from one of the whitelisted addresses" do
      expect { get :create, @request_params }.to raise_error(RuntimeError, "Request to payment gateway from illegal address: 0.0.0.0")
    end

    it "creates a confirmation when called from a whitelisted ip" do
      allow_any_instance_of(ActionDispatch::Request).to receive(:ip).and_return('213.164.23.169')
      get :create, @request_params
      expect(assigns(:confirmation)).to be_a MercatorMpay24::Confirmation
    end

    it "sets all parameters correctly when called from a whitelisted ip" do
      allow_any_instance_of(ActionDispatch::Request).to receive(:ip).and_return('213.164.23.169')
      get :create, @request_params
      expect(assigns(:confirmation).operation).to eql "CONFIRMATION"
      expect(assigns(:confirmation).tid).to eql @payment.id.to_s
      expect(assigns(:confirmation).status).to eql "BILLED"
      expect(assigns(:confirmation).price).to eql "101520"
      expect(assigns(:confirmation).currency).to eql "EUR"
      expect(assigns(:confirmation).p_type).to eql "CC"
      expect(assigns(:confirmation).brand).to eql "VISA"
      expect(assigns(:confirmation).mpaytid).to eql "1793508"
      expect(assigns(:confirmation).user_field).to eql "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4f6bd0d1c98509"
      expect(assigns(:confirmation).orderdesc).to eql "Warenkorb vom Mo, 9.Feb 15,  9:17"
      expect(assigns(:confirmation).customer).to eql "50"
      expect(assigns(:confirmation).customer_email).to eql "some.email@mecator.informatom.com"
      expect(assigns(:confirmation).language).to eql "DE"
      expect(assigns(:confirmation).customer_id).to eql "4711"
      expect(assigns(:confirmation).profile_id).to eql "4811"
      expect(assigns(:confirmation).profile_status).to eql "IGNORED"
      expect(assigns(:confirmation).filter_status).to eql "some status"
      expect(assigns(:confirmation).appr_code).to eql "-test-"
      expect(assigns(:confirmation).payment_id).to eql @payment.id
    end

    it "updates the order when called from a whitelisted ip" do
      allow_any_instance_of(ActionDispatch::Request).to receive(:ip).and_return('213.164.23.169')
      expect_any_instance_of(MercatorMpay24::Confirmation).to receive(:update_order)
      get :create, @request_params
    end

    it "renders nothing when called from a whitelisted ip" do
      allow_any_instance_of(ActionDispatch::Request).to receive(:ip).and_return('213.164.23.169')
      get :create, @request_params
      expect(response.body).to eql("")
    end
  end


  describe "logged_in?" do
    it "returns false" do
      expect(controller.instance_eval{ logged_in? }).to eql false
    end
  end
end