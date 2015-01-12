class PodcastsController < ApplicationController
  hobo_model_controller
  auto_actions :index, :show

  index_action :archive

  before_filter :domain_cms_redirect

  def index
    self.this = Podcast.where.not(published_at: nil)
                       .paginate(page: params[:page], :per_page => 1)
                       .order(published_at: :desc)
    @podcasts= self.this

    if params[:month]
      in_month = params[:month].to_datetime..(params[:month].to_datetime + 1.month)
      self.this = self.this.where(published_at: in_month)
    end

    hobo_index
  end


  def archive
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

end