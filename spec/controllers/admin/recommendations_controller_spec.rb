require 'spec_helper'

describe Admin::RecommendationsController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:recommendation)
      @invalid_attributes = attributes_for(:recommendation, product_id: nil)
    end

    it_behaves_like("crud actions")
  end
end