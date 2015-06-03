require 'spec_helper'

describe Contentmanager::FrontController, :type => :controller do
  describe "before_filters" do
    before :each do
      act_as_user
    end

    it "should check for contentmanager_required" do
      no_redirects
      expect(controller).to receive(:contentmanager_required)
      get :index
    end

    it "redirects to user login path unless user is administrator" do
      get :index
      expect(response).to redirect_to(:user_login)
    end
  end
end