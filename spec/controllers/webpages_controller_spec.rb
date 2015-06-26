require 'spec_helper'

describe WebpagesController, :type => :controller do

  before :each do
    no_redirects and act_as_user
    @page_template = create(:page_template)
    @page_template.save_to_disk
  end

  after :each do
    filename = Rails.root.to_s + "/app/views/page_templates/rspec_test_template.html.erb"
    File.delete(filename)
  end


  describe "GET #show" do
    it "published webpages are presented to user" do
      @webpage = create(:webpage, state: "published",
                                  page_template: @page_template)
      get :show, id: @webpage.id
      expect(response).to have_http_status(301)
    end

    it "draft webpages are hidden from user" do
      @draft = create(:webpage, state: "draft",
                                page_template: @page_template)
      get :show, id: @draft.id
      expect(response).to have_http_status(303)
    end

    it "draft webpages are presented for content manager" do
      @draft = create(:webpage, state: "draft",
                                page_template: @page_template)
      act_as_contentmanager

      get :show, id: @draft.id
      expect(response).to have_http_status(301)
    end
  end
end