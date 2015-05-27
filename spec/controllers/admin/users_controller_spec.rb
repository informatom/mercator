require 'spec_helper'

describe Admin::UsersController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:user)
      @invalid_attributes = attributes_for(:user, email_address: nil)
    end

    it_behaves_like("crud actions")


    describe "GET #index" do
      it "searches for firstname" do
        get :index, search: "John"
        expect(assigns(:users)).to match_array([@instance])
      end

      it "searches for surname" do
        get :index, search: "Doe"
        expect(assigns(:users)).to match_array([@instance])
      end

      it "searches for email address" do
        get :index, search: "john.doe@informatom.com"
        expect(assigns(:users)).to match_array([@instance])
      end

      it "searches returns nil if nothing found" do
        get :index, search: "not in user record"
        expect(assigns(:users)).to match_array([])
      end
    end
  end
end