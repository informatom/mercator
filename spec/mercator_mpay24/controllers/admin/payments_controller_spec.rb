require 'spec_helper'

describe MercatorMpay24::Admin::PaymentsController, :type => :controller do
  routes { MercatorMpay24::Engine.routes }

  describe "GET #check_confirmation" do
    before :each do
      @payment = create(:payment)
    end

    it "finds the payment" do
      allow(@payment).to receive(:check_transaction_status).and_return(:true)
      get :check_confirmation, id: @payment.id
      expect(assigns(:payment)).to eql @payment
    end

    it "check transaction status" do
      expect(@payment).to receive(:check_transaction_status).and_return(:true)
      get :check_confirmation, id: @payment.id
    end

    it "redirects to admin order path" do
      allow(@payment).to receive(:check_transaction_status).and_return(:true)
      get :check_confirmation, id: @payment.id
      expect(response.body).to redirect_to("/admin/orders/" + @payment.order.id.to_s)
    end
  end
end
