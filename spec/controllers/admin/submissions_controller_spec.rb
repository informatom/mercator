require 'spec_helper'

describe Admin::SubmissionsController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:submission)
      @invalid_attributes = attributes_for(:submission, name: nil)
    end

    it_behaves_like("crud actions")
  end
end