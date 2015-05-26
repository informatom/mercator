require 'spec_helper'

describe Admin::FrontController, :type => :controller do

  describe "before_filters" do
    before :each do
      act_as_user
    end

    it "should check for admin_required" do
      no_redirects
      expect(controller).to receive(:admin_required)
      get :index
    end

    it "redirects to user login path unless user is administrator" do
      get :index
      expect(response).to redirect_to(:user_login)
    end
  end


  describe "GET #index" do
    before :each do
      no_redirects and act_as_admin
    end

    it "populates orders_in_payment" do
      @user = create(:user)
      @order = create(:order, user: @user)
      @order_in_payment = create(:order, state: "in_payment",
                                         user: @user)
      get :index
      expect(assigns(:orders_in_payment).to_a).to eql [@order_in_payment]
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end