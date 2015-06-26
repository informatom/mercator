require 'spec_helper'

describe UsersController, :type => :controller do
  before :each do
    no_redirects and act_as_user
  end

  describe "GET #invoices_shipments_payments" do
    it "reads invoices" do
      get :invoices_shipments_payments
      expect(assigns(:invoices)).to be_a Hash
    end

    it "reads open_shipments" do
      get :invoices_shipments_payments
      expect(assigns(:open_shipments)).to be_a Hash
    end

    it "reads open payments" do
      get :invoices_shipments_payments
      expect(assigns(:open_payments)).to be_a Hash
    end
  end
end