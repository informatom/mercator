require 'spec_helper'

describe BlogpostsController, :type => :controller do

  before :each do
    no_redirects and act_as_user
    @content_element = create(:content_element)
    @instance = create(:blogpost, content_element: @content_element)

    @published_blogpost = create(:blogpost, content_element: @content_element,
                                            publishing_date: Date.today)

    @post_category = create(:post_category, name_de: "Meine Kategorie",
                                            name_en: "My Category")
    @second_post_category = create(:post_category, name_de: "Meine zweite Kategorie",
                                                   name_en: "My Second Category")


  end


  describe "GET #index" do
    it_behaves_like("crud index")

    it "shows only published blogposts" do
      get :index
      expect(assigns(:blogposts).count).to eql 1
    end

    it "associated content element needs to have filled content in current locale" do
      @content_element_without_en_content = build(:content_element, content_en: nil)
      @blogpost_without_content = build(:blogpost, content_element: @content_element_without_en_content,
                                                   publishing_date: Date.today,
                                                   title_de: "ohne englischen Inhalt")

      get :index
      expect(assigns(:blogposts).count).to eql 1
    end

    it "filters for tag" do
      @blogpost_with_filter = create(:blogpost, content_element_id: @content_element.id,
                                                publishing_date: Date.today,
                                                title_de: "mit Filter")
      @blogpost_with_filter.blogtag_list.add("my_filter")
      @blogpost_with_filter.save

      get :index, tag: "my_filter"
      expect(assigns(:blogposts).count).to eql 1
    end

    it "filters for post category" do
      @blogpost_in_category = create(:blogpost, post_category_id: @second_post_category.id,
                                                publishing_date: Date.today,
                                                title_de: "In Kategorie",
                                                content_element_id: @content_element.id)

      get :index, post_category_id: @second_post_category.id
      expect(assigns(:blogposts).count).to eql 1
    end

    it "filters for month" do
      @blogpost_from_january_2015 = create(:blogpost, publishing_date: Date.new(2015,1,5),
                                                      title_de: "Jänner 2015",
                                                      post_category_id: @post_category.id,
                                                      content_element_id: @content_element.id)
    end
  end


  describe "GET #feed" do
    it "shows only published blogposts" do
      get :feed, :format => "rss"
      expect(assigns(:blogposts).count).to eql 1
    end

    it "renders feed rss" do
      get :feed, :format => "rss"
      expect(response).to render_template "feed.rss"
    end
  end


  describe "GET #show" do
    it_behaves_like("crud show")

    it "renders episode rss" do
      get :show, id: @published_blogpost.id, :format => "rss"
      expect(response).to render_template "show.rss"
    end
  end
end