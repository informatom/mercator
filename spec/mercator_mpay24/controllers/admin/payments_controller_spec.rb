require 'spec_helper'

describe Admin::PaymentsController, :type => :controller do
  describe "GET #check_confirmation" do
    before :each do
      no_redirects and act_as_admin
      @payment = create(:payment)
    end

    it "finds the payment" do
      allow_any_instance_of(MercatorMpay24::Payment).to receive(:check_transaction_status).and_return(:true)
      get :check_confirmation, id: @payment.id
      expect(assigns(:payment)).to eql @payment
    end

    it "check transaction status" do
      allow_any_instance_of(MercatorMpay24::Payment).to receive(:check_transaction_status).and_return(:true)
      get :check_confirmation, id: @payment.id
    end

    it "redirects to admin order path" do
      allow_any_instance_of(MercatorMpay24::Payment).to receive(:check_transaction_status).and_return(:true)
      get :check_confirmation, id: @payment.id
      expect(response.body).to redirect_to("/admin/orders/" + @payment.order.id.to_s)
    end
  end
end