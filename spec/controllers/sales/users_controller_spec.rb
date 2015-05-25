require 'spec_helper'

describe Sales::UsersController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @instance = create(:user)
      @invalid_attributes = attributes_for(:user, email_address: nil)
    end

    it_behaves_like("crud except destroy")
  end
end