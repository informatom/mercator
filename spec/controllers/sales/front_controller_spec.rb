require 'spec_helper'

describe Sales::FrontController, :type => :controller do

  describe "before_filters" do
    before :each do
      act_as_user
    end

    it "should check for sales_required" do
      no_redirects
      expect(controller).to receive(:sales_required)
      get :index
    end

    it "redirects to user login path unless user is sales" do
      get :index
      expect(response).to redirect_to root_path(locale: nil).chomp("/")
    end
  end
end