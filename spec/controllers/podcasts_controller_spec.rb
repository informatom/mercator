require 'spec_helper'

describe PodcastsController, :type => :controller do

  before :each do
    no_redirects and act_as_user
    @instance = create(:podcast)

    @unpublished_podcast = create(:podcast, published_at: nil,
                                            title: "Noch ein Podcast",
                                            number: 2)
  end


  describe "GET #index" do
    it_behaves_like("crud index")

    it "shows only published podcasts" do
      get :index
      expect(assigns(:podcasts).count).to eql 1
    end

    it "filters for month" do
      @podcasts_from_january_2015 = create(:podcast, published_at: DateTime.new(2015, 1, 5, 12, 11,10),
                                                     title: "Jänner 2015",
                                                     number: 3)
      get :index, month: Date.new(2015,1,5)
      expect(assigns(:podcasts).count).to eql 1
    end
  end


  describe "GET #archive" do
    it "renders the :index template" do
      get :archive
      expect(response).to render_template :archive
    end

    it "shows only published podcasts" do
      get :archive
      expect(assigns(:podcasts).count).to eql 1
    end

    it "filters for month" do
      @podcasts_from_january_2015 = create(:podcast, published_at: DateTime.new(2015, 1, 5, 12, 11,10),
                                                     title: "Jänner 2015",
                                                     number: 4)
      get :archive, month: Date.new(2015,1,5)
      expect(assigns(:podcasts).count).to eql 1
    end
  end


  describe "GET #feed" do
    it "shows only published podcasts" do
      get :feed, :format => "rss"
      expect(assigns(:podcasts).count).to eql 1
    end

    it "renders feed rss" do
      get :feed, :format => "rss"
      expect(response).to render_template "feed.rss"
    end
  end


  describe "GET #ogg" do
    it "shows only published podcasts" do
      get :ogg, :format => "rss"
      expect(assigns(:podcasts).count).to eql 1
    end

    it "renders feed rss" do
      get :ogg, :format => "rss"
      expect(response).to render_template "ogg.rss"
    end
  end


  describe "GET #show" do
    it_behaves_like("crud show")

    it "renders episode rss" do
      get :show, id: @instance.id, :format => "rss"
      expect(response).to render_template "show.rss"
    end
  end
end