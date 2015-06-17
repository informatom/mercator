require 'spec_helper'

describe Admin::ConstantsController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:constant)
      @invalid_attributes = attributes_for(:constant, key: nil)
    end

    it_behaves_like("crud actions")
  end
end