require 'spec_helper'

describe Admin::CategorizationsController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:categorization)
      @invalid_attributes = attributes_for(:categorization, position: nil)
    end

    it_behaves_like("crud actions")
  end
end