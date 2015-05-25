require 'spec_helper'

describe Admin::FeaturesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:feature)
      @invalid_attributes = attributes_for(:feature, position: nil)
    end

    it_behaves_like("crud actions")
  end
end