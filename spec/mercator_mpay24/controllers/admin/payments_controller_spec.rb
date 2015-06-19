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

# Started GET "/mercator_mpay24/admin/payments/68/check_confirmation?locale=de" for 127.0.0.1 at 2015-06-19 20:08:24 +0200
# Processing by MercatorMpay24::Admin::PaymentsController#check_confirmation as HTML
#  Parameters: {"locale"=>"de", "id"=>"68"}


# No route matches {:action=>"check_confirmation", :controller=>"mercator_mpay24/admin/payments", :id=>"1"}
