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


    describe "get #show_webpagestree" do
      it "returns webpages tree" do
        @page_template = create(:page_template)

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


    describe "POST #update_webpages" do
      before :each do
        @page_template = create(:page_template)

        @parent = create(:webpage, page_template_id: @page_template.id)
        @first_webpage = create(:webpage, parent: @parent,
                                          slug: "first",
                                          page_template_id: @page_template.id,
                                          position: 0)
        @second_webpage = create(:webpage, parent: @parent,
                                           slug: "second",
                                           page_template_id: @page_template.id,
                                           position: 1)

        @webpage_param = { "0" => { "key" => "#{@parent.id}", "children" => { "0" => { "key" => "#{@second_webpage}" },
                                                                              "1" => { "key" => "#{@first_webpage}" }
                                                                            }
                                  }
                         }
        # reordered stucture:  @second_webpage <=> @first_webpage
      end

      it "updates the order for the webpages" do
        post :update_webpages, webpages: @webpage_param
        #we have reordered
        @first_webpage.reload
        @second_webpage.reload
        expect(@first_webpage.position).to be 1
        expect(@second_webpage.position).to be 0
      end

      it "renders nothing" do
        post :update_webpages, webpages: @webpage_param
        expect(response.body).to eql("")
      end

      it "calls reorder webpages intrinsically" do
        expect(controller).to receive(:reorder_webpages).with(webpages: @webpage_param, parent_id: nil)
        post :update_webpages, webpages: @webpage_param
      end
    end


    describe "POST #manage_webpage" do
      context "creating a new page" do
        before :each do
          @page_template = create(:page_template)
          @parent = create(:webpage, page_template_id: @page_template.id)

          @params = { "cmd" => "save-record",
                      "recid" => "0",
                      "record" => { "position" => "7",
                                    "parent_id" => "#{@parent.id}",
                                    "title_de" => "Deutscher Titel",
                                    "title_en" => "Englischer Titel",
                                    "state" => { "id" => "draft",
                                                 "text" => "Entwurf"},
                                    "url" => "urltest",
                                    "slug" => "slugtest",
                                    "seo_description" => "seotest",
                                    "page_template_id" => { "id" => "#{@page_template.id}",
                                                            "text" => "main"}},
                                    "id" => "#{@parent.id}"}
          JsonSpec.configure {exclude_keys "created_at", "updated_at"}
        end

        after :each do
          JsonSpec.configure {exclude_keys "created_at", "updated_at", "id"}
        end

        it "creates a new webpage if save record with recid 0" do
          post :manage_webpage, @params
          expect(assigns(:webpage)).to be_a Webpage
        end

        it "sets the webpages attributes" do
          post :manage_webpage, @params
          expect(assigns(:webpage).parent_id).to eq @parent.id
          expect(assigns(:webpage).position).to eq 7
          expect(assigns(:webpage).title_de).to eq "Deutscher Titel"
          expect(assigns(:webpage).title_en).to eq "Englischer Titel"
          expect(assigns(:webpage).state).to eq "draft"
          expect(assigns(:webpage).url).to eq "urltest"
          expect(assigns(:webpage).slug).to eq "slugtest"
          expect(assigns(:webpage).seo_description).to eq "seotest"
          expect(assigns(:webpage).page_template_id).to eq @page_template.id
        end

        it 'sets in session selected webpage id' do
          post :manage_webpage, @params
          expect(session[:selected_webpage_id]).to eql assigns(:webpage).id
        end

        it "returns the correct json" do
          post :manage_webpage, @params
          expect(response.body).to be_json_eql({record: { page_template_id: { id: @page_template.id },
                                                          position: 7,
                                                          recid: assigns(:webpage).id,
                                                          seo_description: "seotest",
                                                          slug: "slugtest",
                                                          state: { id: "draft" },
                                                          title_de: "Deutscher Titel",
                                                          title_en: "Englischer Titel",
                                                          url: "urltest" },
                                                status: "success"}.to_json)
        end
      end


      context "updating a page" do
        before :each do
          @page_template = create(:page_template)
          @second_page_template = create(:page_template, name: "another page template")
          @webpage = create(:webpage, page_template_id: @page_template.id)

          @params = {"cmd" => "save-record",
                     "recid" => "#{@webpage.id}",
                     "record" => { "recid" => "#{@webpage.id}",
                                   "title_de" => "updated title_de",
                                   "title_en" => "updated title_en",
                                   "state" => { "id"=>"draft",
                                                "text"=>"Entwurf"},
                                   "url" => "updated url",
                                   "slug" => "updated slug",
                                   "seo_description" => "updated seo",
                                   "position"=> "1",
                                   "page_template_id" => { "id"=>"#{@second_page_template.id}",
                                                           "text"=>"main"}},
                     "id" => "#{@webpage.id}"}
        end

        it "reads the right record" do
          post :manage_webpage, @params
          expect(assigns(:webpage)).to eq @webpage
        end

        it "updates the data" do
          post :manage_webpage, @params
          expect(assigns(:webpage).position).to eq 1
          expect(assigns(:webpage).title_de).to eq "updated title_de"
          expect(assigns(:webpage).title_en).to eq "updated title_en"
          expect(assigns(:webpage).state).to eq "draft"
          expect(assigns(:webpage).url).to eq "updated url"
          expect(assigns(:webpage).slug).to eq "updated slug"
          expect(assigns(:webpage).seo_description).to eq "updated seo"
          expect(assigns(:webpage).page_template_id).to eq @second_page_template.id
        end

        it "returns the records data" do
          post :manage_webpage, @params
          expect(response.body).to be_json_eql({record: { page_template_id: { id: assigns(:webpage).page_template.id },
                                                          position:         assigns(:webpage).position,
                                                          recid:            assigns(:webpage).id,
                                                          seo_description:  assigns(:webpage).seo_description,
                                                          slug:             assigns(:webpage).slug,
                                                          state:            { id: assigns(:webpage).state },
                                                          title_de:         assigns(:webpage).title_de,
                                                          title_en:         assigns(:webpage).title_en,
                                                          url:              assigns(:webpage).url },
                                                status: "success"}.to_json)
        end
      end


      context "reading a page" do
        before :each do
          @page_template = create(:page_template)
          @webpage = create(:webpage, page_template_id: @page_template.id)

          @params = {"cmd" => "read-record",
                     "recid" => "#{@webpage.id}",
                     "id" => "#{@webpage.id}"}
        end

        it "reads the right record" do
          post :manage_webpage, @params
          expect(assigns(:webpage)).to eq @webpage
        end

        it "returns the records data" do
          post :manage_webpage, @params
          expect(response.body).to be_json_eql({record: { page_template_id: { id: assigns(:webpage).page_template.id },
                                                          position:         assigns(:webpage).position,
                                                          recid:            assigns(:webpage).id,
                                                          seo_description:  assigns(:webpage).seo_description,
                                                          slug:             assigns(:webpage).slug,
                                                          state:            { id: assigns(:webpage).state },
                                                          title_de:         assigns(:webpage).title_de,
                                                          title_en:         assigns(:webpage).title_en,
                                                          url:              assigns(:webpage).url },
                                                status: "success"}.to_json)
        end
      end
    end


    describe "GET #show_assignments" do
      before :each do
        @page_template = create(:page_template)
        @page_template.placeholder_list.add("tag_one")
        @page_template.placeholder_list.add("tag_two")
        @page_template.save # otherwise placeholders are not persisted

        @webpage = create(:webpage, page_template_id: @page_template.id)

        @content_element = create(:content_element)
        @assignment = create(:page_content_element_assignment, webpage_id: @webpage.id,
                                                               content_element_id: @content_element.id,
                                                               used_as: "tag_one")
        @another_assignment = create(:page_content_element_assignment, webpage_id: @webpage.id,
                                                                       content_element_id: @content_element.id,
                                                                       used_as: "tag_two")
        JsonSpec.configure {exclude_keys "created_at", "updated_at"}
      end

      after :each do
        JsonSpec.configure {exclude_keys "created_at", "updated_at", "id"}
      end

      it "reads the webpage" do
        get :show_assignments, id: @webpage.id
        expect(assigns(:webpage)).to eql @webpage
      end

      it "calls add_missing_page_content_element_assignments on the webpage" do
        expect_any_instance_of(Webpage).to receive :add_missing_page_content_element_assignments
        get :show_assignments, id: @webpage.id
      end

      it "calls delete_orphaned_page_content_element_assignments on the webpage" do
        expect_any_instance_of(Webpage).to receive :delete_orphaned_page_content_element_assignments
        get :show_assignments, id: @webpage.id
      end

      it "calls reloads the the webpage" do
        expect_any_instance_of(Webpage).to receive :reload
        get :show_assignments, id: @webpage.id
      end

      it "reads the assignments" do
        get :show_assignments, id: @webpage.id
        expect(assigns(:assignments)).to match_array [@assignment, @another_assignment]
      end

      it "returns json" do
        get :show_assignments, id: @webpage.id
        expect(response.body).to be_json_eql({ records: [{ content_element_name: "I am the english title",
                                                           recid: @assignment.id,
                                                           used_as: "tag_one" },
                                                         { content_element_name: "I am the english title",
                                                           recid: @another_assignment.id,
                                                           used_as: "tag_two"} ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #update_folders" do
      before :each do
        @parent = create(:folder)
        @first_folder = create(:folder, parent: @parent,
                                        position: 0)
        @second_folder = create(:folder, parent: @parent,
                                         position: 1)

        @folders_param = { "0" => { "key" => "#{@parent.id}", "children" => { "0" => { "key" => "#{@second_folder.id}" },
                                                                              "1" => { "key" => "#{@first_folder.id}" }
                                                                            }
                                  }
                         }
        # reordered stucture:  @second_folder <=> @first_folder
      end

      it "updates the order for the folders" do
        post :update_folders, folders: @folders_param
        #we have reordered
        @first_folder.reload
        @second_folder.reload
        expect(@first_folder.position).to be 1
        expect(@second_folder.position).to be 0
      end

      it "renders nothing" do
        post :update_folders, folders: @folders_param
        expect(response.body).to eql("")
      end

      it "calls reorder folders intrinsically" do
        expect(controller).to receive(:reorder_folders).with(folders: @folders_param, parent_id: nil)
        post :update_folders, folders: @folders_param
      end
    end


    describe "GET #show_content_elements" do
      before :each do
        @folder = create(:folder)
        @content_element = create(:content_element, folder_id: @folder.id)
        @second_content_element = create(:content_element, folder_id: @folder.id,
                                                           name_de: "noch ein Baustein",
                                                           photo: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg'),
                                                           document: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf'))
        JsonSpec.configure {exclude_keys "created_at", "updated_at", "photo_url", "thumb_url"}
      end

      after :each do
        JsonSpec.configure {exclude_keys "created_at", "updated_at", "id"}
      end

      it "reads the content elements" do
        get :show_content_elements, id: @folder.id
        expect(assigns(:content_elements)).to match_array [@content_element, @second_content_element]
      end

      it "renders content elements the json" do
        get :show_content_elements, id: @folder.id
        expect(response.body).to be_json_eql({ records: [{ content_de: "Ich bin der deutsche Inhalt",
                                                           content_en: "I am the English content",
                                                           document_file_name: nil,
                                                           markup: "html",
                                                           name_de: "Ich bin der deutsche Titel",
                                                           name_en: "I am the english title",
                                                           photo_file_name: nil,
                                                           recid: @content_element.id },
                                                         { content_de: "Ich bin der deutsche Inhalt",
                                                           content_en: "I am the English content",
                                                           document_file_name: "dummy_document.pdf",
                                                           markup: "html",
                                                           name_de: "noch ein Baustein",
                                                           name_en: "I am the english title",
                                                           photo_file_name: "dummy_image.jpg",
                                                           recid: @second_content_element.id }],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #update_content_element" do
      before :each do
        @old_folder = create(:folder, position: 0)
        @new_folder = create(:folder, position: 1)
        @content_element = create(:content_element, folder_id: @old_folder.id)
      end

      it "reads the right content element" do
        post :update_content_element, id: @content_element.id,
                                      folder_id: @new_folder.id
        expect(assigns(:content_element)).to eql @content_element
      end

      it "updates the folder id" do
        post :update_content_element, id: @content_element.id,
                                      folder_id: @new_folder.id
        expect(assigns(:content_element).folder_id).to eql @new_folder.id
      end

      it "returns the old folder id" do
        post :update_content_element, id: @content_element.id,
                                      folder_id: @new_folder.id
        expect(response.body).to eql @old_folder.id.to_s
      end
    end


    describe "POST update_page_content_element_assignment" do
      before :each do
        @page_template = create(:page_template)
        @page_template.placeholder_list.add("tag_one")
        @page_template.save # otherwise placeholders are not persisted

        @webpage = create(:webpage, page_template_id: @page_template.id)

        @content_element = create(:content_element)
        @assignment = create(:page_content_element_assignment, webpage_id: @webpage.id,
                                                               content_element_id: nil,
                                                               used_as: "tag_one")
      end

      it "reads the right page content element assignment" do
        post :update_page_content_element_assignment, id: @assignment.id,
                                                      content_element_id: @content_element.id
        expect(assigns(:page_content_element_assignment)).to eql @assignment
      end

      it "updates the content element id" do
        post :update_page_content_element_assignment, id: @assignment.id,
                                                      content_element_id: @content_element.id
        expect(assigns(:page_content_element_assignment).content_element_id).to eql @content_element.id
      end

      it "returns the webpage id" do
        post :update_page_content_element_assignment, id: @assignment.id,
                                                      content_element_id: @content_element.id
        expect(response.body).to eql assigns(:page_content_element_assignment).webpage_id.to_s
      end
    end


    describe "DELETE #delete_assignment" do
      before :each do
        @page_template = create(:page_template)
        @page_template.placeholder_list.add("tag_one")
        @page_template.save # otherwise placeholders are not persisted

        @webpage = create(:webpage, page_template_id: @page_template.id)

        @content_element = create(:content_element)
        @assignment = create(:page_content_element_assignment, webpage_id: @webpage.id,
                                                               content_element_id: @content_element.id,
                                                               used_as: "tag_one")
      end

      it "reads the right page content element assignment" do
        post :delete_assignment, id: @assignment.id
        expect(assigns(:page_content_element_assignment)).to eql @assignment
      end

      it "updates the content element id" do
        post :delete_assignment, id: @assignment.id
        expect(assigns(:page_content_element_assignment).content_element_id).to eql nil
      end

      it "returns the webpage id" do
        post :delete_assignment, id: @assignment.id
        expect(response.body).to eql assigns(:page_content_element_assignment).webpage_id.to_s
      end
    end


    describe "POST #content_element" do
      before :each do
        @content_element = create(:content_element, photo: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg'),
                                                    document: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf'))
      end

      it "reads the content element" do
        post :content_element, recid: @content_element.id
        expect(assigns(:content_element)).to eql @content_element
      end

      it "returns the json data" do
        post :content_element, recid: @content_element.id
        expect(response.body).to be_json_eql({record: {content_de: "Ich bin der deutsche Inhalt",
                                                       content_en: "I am the English content",
                                                       document: "dummy_image.jpg",
                                                       markup: "html",
                                                       name_de: "Ich bin der deutsche Titel",
                                                       name_en: "I am the english title",
                                                       photo: "dummy_image.jpg",
                                                       recid: @content_element.id },
                                              status: "success"} .to_json)
      end
    end


    describe "GET #get_thumbnails" do
      before :each do
        @folder = create(:folder, position: 1)
        @content_element_without_photo = create(:content_element, photo: nil,
          document: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf'),
                                                                  folder_id: @folder.id,
                                                                  name_de: "ohne Photo")
        @content_element_with_photo = create(:content_element, folder_id: @folder.id,
          photo: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg'),
                                                               name_de: "mit Photo")
      end

      it "reads the content elements" do
        get :get_thumbnails, id: @folder.id
        expect(assigns(:content_elements)).to match_array [@content_element_with_photo]
      end

      it "sets in session the selected folder id" do
        get :get_thumbnails, id: @folder.id
        expect(session[:selected_folder_id]).to eql @folder.id
      end
    end


    describe "POST #set_seleted_content_element" do
      it "sets in session the selected oontent element id" do
        post :set_seleted_content_element, id: 17
        expect(session[:selected_content_element_id]).to eql 17
      end

      it "renders json success: true" do
        post :set_seleted_content_element, id: 17
        expect(response.body).to be_json_eql({ status: "success" } .to_json)
      end
    end

  end

  # reorder_webpages is tested inherently by update_webpages
  # reorder_folders is tested inherently by update_folders
  # childrenarray is tested inherently by show_foldertree and show_webpagestree
end