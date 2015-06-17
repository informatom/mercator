require 'spec_helper'

describe Admin::CountriesController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:country)
      @invalid_attributes = attributes_for(:country, name_de: nil)
    end

    it_behaves_like("crud actions")
  end
end