require 'spec_helper'

describe Admin::PropertyGroupsController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:property_group)
      @invalid_attributes = attributes_for(:property_group, amount: nil)
    end

    it_behaves_like("crud actions")
  end
end