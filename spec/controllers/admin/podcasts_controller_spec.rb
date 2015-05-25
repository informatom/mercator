require 'spec_helper'

describe Admin::PodcastsController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:podcast)
      @invalid_attributes = attributes_for(:podcast, number: nil)
    end

    it_behaves_like("crud actions")
  end
end