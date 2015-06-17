require 'spec_helper'

describe Admin::ChaptersController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:chapter)
      @invalid_attributes = attributes_for(:chapter, start: nil)
    end

    it_behaves_like("crud actions")
  end
end