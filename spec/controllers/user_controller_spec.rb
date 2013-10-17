require 'spec_helper'

describe UsersController do
  it "saves the user to the database" do
    expect{
      post :do_signup, user: attributes_for(:user, password_confirmation: "secret123")
    }.to change(User, :count).by(1)
  end

  it "redirects to the home page upon signup" do
    post :do_signup, user: attributes_for(:user, password_confirmation: "secret123")
    expect(response).to redirect_to ""
  end
end
