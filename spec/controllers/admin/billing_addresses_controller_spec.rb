require 'spec_helper'

describe Admin::BillingAddressesController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      country = create(:country)
      @instance = create(:billing_address, country: country.name_de)
      @invalid_attributes = attributes_for(:billing_address, country: nil)
    end

    it_behaves_like("crud actions")
  end
end