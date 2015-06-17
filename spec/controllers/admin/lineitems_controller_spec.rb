require 'spec_helper'

describe Admin::LineitemsController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:lineitem)
      @invalid_attributes = attributes_for(:lineitem, order_id: nil, user_id: nil)
    end

    it_behaves_like("crud actions")
  end
end