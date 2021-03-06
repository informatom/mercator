require 'spec_helper'

describe Admin::GtcsController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:gtc)
      @invalid_attributes = attributes_for(:gtc, title_de: nil)
    end

    it_behaves_like("crud actions")
  end
end