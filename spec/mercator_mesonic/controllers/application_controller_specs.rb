require 'spec_helper'

describe MercatorMesonic::ApplicationController, :type => :controller do
  routes { MercatorMesonic::Engine.routes }

  describe "get #import" do
    before :each do
      act_as_admin and no_redirects
    end

    it "imports webartikel" do
      expect(Delayed::Job).to receive(:enqueue).and_return true
      get :import
    end

    it "redirects to admin_logentries_path" do
      expect(Delayed::Job).to receive(:enqueue).and_return true
      get :import
      expect(response.body).to redirect_to "/admin/logentries"
    end
  end


  describe "admin_required" do
    before :each do
      act_as_user
    end

    it "should check for admin_required" do
      no_redirects
      expect(controller).to receive(:admin_required)
      get :import
    end

    it "redirects to user login path unless user is administrator" do
      get :import
      expect(response).to redirect_to(:user_login)
    end
  end
end