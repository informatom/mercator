require 'spec_helper'

describe Admin::AddressesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      country = create(:country)
      @instance = create(:address, country: country.name_de)
      @instance_attributes = attributes_for(:address, company: nil)
      @delete_redirect = admin_addresses_url
    end

    it_behaves_like("crud actions")
  end
end