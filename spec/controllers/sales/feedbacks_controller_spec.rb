require 'spec_helper'

describe Sales::FeedbacksController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_salesmanager

      @instance = create(:feedback, consultant: @salesmanager)
      @invalid_attributes = { content: nil }
    end

    it_behaves_like("crud except destroy")
  end
end