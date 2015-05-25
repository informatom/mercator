require 'spec_helper'

describe Admin::SupplyrelationsController , :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:supplyrelation)
      @invalid_attributes = attributes_for(:supplyrelation, product_id: nil)
    end

    it_behaves_like("crud actions")
  end
end