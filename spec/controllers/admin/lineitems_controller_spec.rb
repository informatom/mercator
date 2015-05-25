require 'spec_helper'

describe Admin::LineitemsController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @user = create(:user)
      @order = create(:order, user: @user)
      @instance = create(:lineitem, order: @order, user: @user)
      @invalid_attributes = attributes_for(:lineitem, position: nil)
    end

    it_behaves_like("crud actions")
  end
end