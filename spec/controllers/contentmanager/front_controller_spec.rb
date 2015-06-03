require 'spec_helper'

describe Contentmanager::FrontController, :type => :controller do
  describe "before_filters" do
    before :each do
      act_as_user
    end

    it "should check for contentmanager_required" do
      no_redirects
      expect(controller).to receive(:contentmanager_required)
      get :index
    end

    it "redirects to user login path unless user is administrator" do
      get :index
      expect(response).to redirect_to(:user_login)
    end
  end

  describe "actions" do
    before :each do
      no_redirects && act_as_contentmanager
    end


    describe "get #show_foldertree" do
      it "returns folder tree" do
        @grandparent = create(:folder)
        @parent = create(:folder, parent: @grandparent)
        @folder = create(:folder, parent: @parent)

        get :show_foldertree
        expect(response.body).to be_json_eql([{children: [{ children: [{ folder: true,
                                                                         key: @folder.id,
                                                                         title: "texts", } ],
                                                            folder: true,
                                                            key: @parent.id,
                                                            title: "texts"} ],
                                               folder: true,
                                               key: @grandparent.id,
                                               title: "texts"} ] .to_json)
      end
    end


    describe "get #show_webpagestree", focus: true do
      it "returns webpages tree" do
        @page_template = create(:page_template, name: "old version", created_at: Time.now - 24.hours)
        @page_template.update(name: "new_version")

        @grandparent = create(:webpage, page_template_id: @page_template.id)
        @parent = create(:webpage, parent: @grandparent,
                                   slug: "Elternseite",
                                   page_template_id: @page_template.id)
        @webpage = create(:webpage, parent: @parent,
                                    slug: "Großelternseite",
                                    page_template_id: @page_template.id)

        get :show_webpagestree
        expect(response.body).to be_json_eql([{children: [{ children: [{ folder: false,
                                                                         key: @webpage.id,
                                                                         title: "Titel of a Webpage <em style='color: green'>draft</em>"} ],
                                                            folder: false,
                                                            key: @parent.id,
                                                            title: "Titel of a Webpage <em style='color: green'>draft</em>"} ],
                                               folder: false,
                                               key: @grandparent.id,
                                               title: "Titel of a Webpage <em style='color: green'>draft</em>"} ] .to_json)
      end
    end
  end

  # Childrenarray is tested inherently by show_foldertree and show_webpagestree
end