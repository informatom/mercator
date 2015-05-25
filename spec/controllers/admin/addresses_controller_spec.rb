require 'spec_helper'

describe Admin::AddressesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      country = create(:country)
      @instance = create(:address, country: country.name_de)
      @invalid_attributes = attributes_for(:address, country: nil)
    end

    it_behaves_like("crud actions")
  end
end