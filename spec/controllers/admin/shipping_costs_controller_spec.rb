require 'spec_helper'

describe Admin::ShippingCostsController , :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:shipping_cost)
      @invalid_attributes = attributes_for(:shipping_cost, shipping_method: nil)
    end

    it_behaves_like("crud actions")
  end
end