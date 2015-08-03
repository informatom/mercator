require 'spec_helper'

describe Admin::OrdersController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:order)
      @invalid_attributes = attributes_for(:order, discount_rel: nil)
    end

    it_behaves_like("crud except create")


    describe 'DELETE #destroy' do
      it "redirects to #index" do
        delete :destroy, id: @instance
        expect(response).to redirect_to admin_orders_path
      end
    end


    describe "GET #index" do
      it "returns all orders" do
        get :index
        expect(assigns(:orders)).to match_array([@instance])
      end

      it "filters state and returns nil" do
        get :index, in_payment: "true"
        expect(assigns(:orders)).to match_array([])
      end

      it "creates the correct json" do
        create(:second_order, user_id: @instance.user.id)

        get :index, format: :text
        expect(response.body).to be_json_eql({ records: [ { billing_company: "Bigcorp",
                                                            billing_method: "E-Payment",
                                                            created_at_date: Time.now.to_date(),
                                                            created_at_time: Time.now.to_s(:time),
                                                            erp_billing_number: "b123",
                                                            erp_customer_number: "a123",
                                                            erp_order_number: "o123",
                                                            lineitems: 0,
                                                            recid: 1,
                                                            shipping_company: "Bigcorp",
                                                            shipping_method: "Shipment by Parcel Service",
                                                            state: "basket",
                                                            sum_incl_vat: 0,
                                                            updated_at_date: Time.now.to_date(),
                                                            updated_at_time: Time.now.to_s(:time),
                                                            user: "Mr. Dr John Doe" },
                                                          { billing_company: "Bigcorp",
                                                            billing_method: "Prepayment",
                                                            created_at_date: Time.now.to_date(),
                                                            created_at_time: Time.now.to_s(:time),
                                                            erp_billing_number: "b123",
                                                            erp_customer_number: "a123",
                                                            erp_order_number: "o123",
                                                            lineitems: 0,
                                                            recid: 2,
                                                            shipping_company: "Bigcorp",
                                                            shipping_method: "Shipment by Parcel Service",
                                                            state: "basket",
                                                            sum_incl_vat: 0,
                                                            updated_at_date: Time.now.to_date(),
                                                            updated_at_time: Time.now.to_s(:time),
                                                            user: "Mr. Dr John Doe" }
                                                        ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe 'POST #create' do
      it "with incorrect data it rerenders #new" do
        post :create, attributes_for(:order)
        expect(response).to redirect_to admin_order_path(assigns[:order])
      end
    end
  end


  context "lifecycle actions" do
    before :each do
      no_redirects and act_as_admin
    end

    describe "PUT #do_shippment" do
      it "is avalible for paid for admin" do
        @paid_order = create(:order, state: "paid")
        expect(@paid_order.lifecycle.can_shippment?(@admin)).to be
      end
    end
  end
end