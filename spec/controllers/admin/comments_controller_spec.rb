require 'spec_helper'

describe Admin::CommentsController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:comment)
      @invalid_attributes = attributes_for(:comment, content: nil)
    end

    it_behaves_like("crud actions")
  end
end