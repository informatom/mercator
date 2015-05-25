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
end