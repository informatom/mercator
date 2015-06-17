require 'spec_helper'

describe Admin::BlogpostsController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:blogpost)
      @invalid_attributes = attributes_for(:blogpost, title_de: nil)
    end

    it_behaves_like("crud actions")
  end
end