require 'spec_helper'

describe Admin::InventoriesController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:inventory)
      @invalid_attributes = attributes_for(:inventory, name_de: nil)
    end

    it_behaves_like("crud actions")
  end
end