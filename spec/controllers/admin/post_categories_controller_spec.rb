require 'spec_helper'

describe Admin::PostCategoriesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:post_category)
      @invalid_attributes = {name_de: nil, name_en: "Important Blogposts"}
    end

    it_behaves_like("crud actions")
  end
end