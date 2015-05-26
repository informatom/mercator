require 'spec_helper'

describe Admin::PageTemplatesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:page_template)
      @invalid_attributes = attributes_for(:page_template, name: nil)
    end

    it_behaves_like("crud actions")


    it "should save to disk on create" do
      filename = Rails.root.to_s + "/app/views/page_templates/rspec_test_template.html.erb"
      File.delete(filename) if File.exist?(filename)
      expect(File).not_to exist(filename)

      post :create, page_template: attributes_for(:page_template)

      expect(File).to exist(filename)
      File.delete(filename)
    end


    it "should save to disk on update" do
      filename = Rails.root.to_s + "/app/views/page_templates/rspec_new_test_template.html.erb"
      File.delete(filename) if File.exist?(filename)
      expect(File).not_to exist(filename)

      patch :update, id: @instance,
                     page_template: attributes_for(:page_template, name: "rspec_new_test_template")

      expect(File).to exist(filename)
      File.delete(filename)
    end


    it "loads older version for edit if specified", :versioning => true do
      @page_template = create(:page_template, name: "old version", created_at: Time.now - 24.hours)
      @page_template.update(name: "new_version")

      get :edit, id: @page_template, version: 3

      expect(assigns(:page_template)).to eql(@page_template.versions.last.reify)
    end
  end

  describe "restart" do
    it "restarts the application" do
      no_redirects and act_as_admin
      expect(controller).to receive(:exec).with("touch " + Rails.root.to_s + "/tmp/restart.txt &")

      get :restart
    end
  end
end