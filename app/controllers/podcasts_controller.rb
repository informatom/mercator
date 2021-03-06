class PodcastsController < ApplicationController
  before_filter :domain_cms_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions :index, :show


  def index
    page = params[:page] ? params[:page].to_i : 1

    self.this = Podcast.where.not(published_at: nil)
                       .paginate(page: page, :per_page => 1)
                       .order(published_at: :desc)

    if params[:month]
      in_month = params[:month].to_datetime..(params[:month].to_datetime + 1.month)
      self.this = self.this.where(published_at: in_month)
    end

    @podcasts = self.this
    hobo_index
  end


  index_action :archive do
    self.this = Podcast.where.not(published_at: nil)
                       .paginate(page: params[:page], :per_page => 10)
                       .order(published_at: :desc)
    @podcasts= self.this

    if params[:month]
      in_month = params[:month].to_datetime..(params[:month].to_datetime + 1.month)
      self.this = self.this.where(published_at: in_month)
    end

    hobo_index
  end


  index_action :feed do
    @podcasts = Podcast.where.not(published_at: nil)
    render 'feed.rss'
  end


  index_action :ogg do
    @podcasts = Podcast.where.not(published_at: nil)
    render 'ogg.rss'
  end


  def show
    hobo_show do
      render 'show.rss' if request.format.rss?
    end
  end
end