require 'spec_helper'

describe Contracting::UsersController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @instance = create(:user)
      @invalid_attributes = attributes_for(:user, email_address: nil)
    end

    it_behaves_like("crud except destroy")
  end
end