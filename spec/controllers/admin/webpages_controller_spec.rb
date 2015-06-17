require 'spec_helper'

describe Admin::WebpagesController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @page_template = create(:page_template)
      @page_template.save_to_disk
      @instance = create(:webpage, page_template_id: @page_template.id)
      @attributes = attributes_for(:webpage, page_template_id: @page_template.id,
                                             slug: "another slug")
      @invalid_attributes = attributes_for(:webpage, title_de: nil)
    end

    it_behaves_like("crud actions")


    describe 'GET #index' do
      it "searches for name_de" do
        get :index, search: "Website"
        expect(assigns(:webpages).count).to eql 1
      end

      it "searches for name_en" do
        get :index, search: "Webpage"
        expect(assigns(:webpages).count).to eql 1
      end

      it "if term not searchable, nothing is returned" do
        get :index, search: "not findable"
        expect(assigns(:webpages).count).to eql 0
      end
    end


    describe 'GET #show' do
      it 'finds by slug' do
        get :show, id: "mypage"
        expect(assigns(:webpage)).to eql @instance
      end
    end


    describe 'POST #create' do
      it "sets session selected webpage id" do
        post :create, webpage: @attributes
        expect(session[:selected_webpage_id]).to eql assigns(:webpage).id
      end

      it "redirects to contentmanager front path" do
        post :create, webpage: @attributes
        expect(response).to redirect_to contentmanager_front_path
      end
    end


    describe 'GET #edit' do
      it 'finds by slug' do
        get :edit, id: "mypage"
        expect(assigns(:webpage)).to eql @instance
      end

      it "sets session selected webpage id" do
        get :edit, id: "mypage"
        expect(session[:selected_webpage_id]).to eql @instance.id
      end
    end


    describe 'PATCH #update' do
      it 'finds by slug' do
        patch :update, id: "mypage", webpage: { title_de: "new title" }
        expect(assigns(:webpage)).to eql @instance
      end

      it "sets session selected webpage id" do
        patch :update, id: "mypage", webpage: { title_de: "new title" }
        expect(session[:selected_webpage_id]).to eql @instance.id
      end

      it "redirects to contentmanager front path" do
        patch :update, id: "mypage", webpage: { title_de: "new title" }
        expect(response).to redirect_to contentmanager_front_path
      end
    end


    describe 'DELETE #destroy' do
      it 'finds by slug' do
        patch :update, id: "mypage", webpage: { title_de: "new title" }
        expect(assigns(:webpage)).to eql @instance
      end

      it "responds with 403 for non existing webpage" do
        delete :destroy, id: 999
        expect(response).to have_http_status(403)
      end

      it "responds with 403 if webpage has children" do
        create(:webpage, parent: @instance,
                         slug: "Elternseite",
                         page_template_id: @page_template.id)
        delete :destroy, id: @instance
        expect(response).to have_http_status(403)
      end

      it "renders nothing for xhr request" do
        xhr :delete, :destroy, id: @instance
        expect(response.body).to eql(" ")
      end
    end


    describe "livecycle actions" do
      describe "PUT #do_publish" do
        it "redirects to contentmanager front path" do
          put :do_publish, id: @instance.id
          expect(response).to redirect_to contentmanager_front_path
        end

        it "sets session key selected_webpage_id" do
          put :do_publish, id: @instance.id
          expect(session[:selected_webpage_id]).to eql @instance.id
        end

        it "is available for state draft" do
          @instance.state = "draft"
          expect(@instance.lifecycle.can_publish? @admin).to be
        end

        it "is available for archived" do
          @instance.state = "archived"
          expect(@instance.lifecycle.can_publish? @admin).to be
        end
      end


      describe "PUT #do_archive" do
        it "redirects to contentmanager front path" do
          @instance.update(state: "published")
          put :do_archive, id: @instance.id
          expect(response).to redirect_to contentmanager_front_path
        end

        it "sets session key selected_webpage_id" do
          @instance.update(state: "published")
          put :do_archive, id: @instance.id
          expect(session[:selected_webpage_id]).to eql @instance.id
        end

        it "is available for published" do
          @instance.state = "published"
          expect(@instance.lifecycle.can_archive? @admin).to be
        end

        it "is available for published_but_hidden" do
          @instance.state = "published_but_hidden"
          expect(@instance.lifecycle.can_archive? @admin).to be
        end
      end


      describe "PUT #do_hide" do
        it "redirects to contentmanager front path" do
          @instance.update(state: "published")
          put :do_hide, id: @instance.id
          expect(response).to redirect_to contentmanager_front_path
        end

        it "sets session key selected_webpage_id" do
          @instance.update(state: "published")
          put :do_hide, id: @instance.id
          expect(session[:selected_webpage_id]).to eql @instance.id
        end
      end


      describe "PUT #do_unhide" do
        it "redirects to contentmanager front path" do
          @instance.update(state: "published_but_hidden")
          put :do_unhide, id: @instance.id
          expect(response).to redirect_to contentmanager_front_path
        end

        it "sets session key selected_webpage_id" do
          @instance.update(state: "published_but_hidden")
          put :do_unhide, id: @instance.id
          expect(session[:selected_webpage_id]).to eql @instance.id
        end
      end
    end
  end
end