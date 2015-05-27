require 'spec_helper'

describe Admin::OrdersController, :type => :controller do

  describe "crud actions" do
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
      it "filters baskets" do
        get :index, search: "basket"
        expect(assigns(:orders)).to match_array([@instance])
      end

      it "filters state and returns nil" do
        get :index, search: "active"
        expect(assigns(:orders)).to match_array([])
      end
    end


    describe 'POST #create' do
      it "with incorrect data it rerenders #new" do
        post :create, attributes_for(:order)
        expect(response).to redirect_to admin_order_path(assigns[:order])
      end
    end
  end
end