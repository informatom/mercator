require 'spec_helper'

describe OrdersController, :type => :controller do

  describe "actions" do
    before :each do
      no_redirects and act_as_admin
      create(:mpay_test_username)
      create(:mpay_test_password)
      @test_message = "<merchantID>undefined</merchantID><mdxi><Order><Tid>0815/4711</Tid><Price>12.34</Price></Order></mdxi>"
    end

    context "Test Payment class" do
      it "creates a test payment message" do
        response = instance_double(Savon::Response, :body => Hash.new(:location => "http://www.informatom.com"))
        allow(Order::MPAY_TEST_CLIENT).to receive(:call) { response }

        get :test_payment
        expect(assigns(:test_message).to_s).to eql @test_message
      end
    end

    describe 'GET #test_payment' do
      it "calls a test payment" do
        response = instance_double(Savon::Response, :body => Hash.new(:location => "http://www.informatom.com"))
        allow(Order::MPAY_TEST_CLIENT).to receive(:call) { response }

        expect(Order::MPAY_TEST_CLIENT).to receive(:call)
        get :test_payment
      end

      it "redirects" do
        response = instance_double(Savon::Response, :body => Hash.new(:location => "http://www.informatom.com"))
        allow(Order::MPAY_TEST_CLIENT).to receive(:call) { response }

        get :test_payment
        expect(response.body).to redirect_to("http://www.informatom.com")
      end
    end
  end
end