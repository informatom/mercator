require 'spec_helper'

describe Admin::PageContentElementAssignmentsController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:page_content_element_assignment)
      @invalid_attributes = attributes_for(:page_content_element_assignment, used_as: nil)
    end

    it_behaves_like("crud actions")
  end
end