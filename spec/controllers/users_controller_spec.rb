require 'spec_helper'

describe UsersController, :type => :controller do
  before :each do
    no_redirects and act_as_user
  end

  describe 'GET #show' do
    it "renders the :show template" do
      get :show, id: @user
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it "renders the :show template" do
      get :edit, id: @user
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    it "with correct data it redirects to #show" do
      patch :update, id: @user.id, user: { email_address: "new.address@mercator.informatom.com"}
      expect(response.body).to redirect_to user_path(assigns(:user))
    end
  end
end