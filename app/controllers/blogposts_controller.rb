class BlogpostsController < ApplicationController
  hobo_model_controller
  auto_actions :index, :show
  index_action :feed

  before_filter :domain_cms_redirect

  def index
    page = params[:page] ? params[:page].to_i : 1

    self.this = Blogpost.joins(:content_element)
                        .where.not(publishing_date: nil)
                        .order(publishing_date: :desc)
                        .merge(ContentElement.where
                                             .not(ContentElement.current_locale_column(:content) => [nil, ""]))
                        .paginate(page: page)
    self.this = self.this.tagged_with(params[:tag]) if params[:tag]
    self.this = self.this.where(post_category_id: params[:post_category_id]) if params[:post_category_id]

    if params[:month]
      in_month = params[:month].to_datetime..(params[:month].to_datetime + 1.month)
      self.this = self.this.where(publishing_date: in_month)
    end

    @blogposts = self.this
    hobo_index
  end

  def feed
    @blogposts = Blogpost.where.not(publishing_date: nil)
    render 'feed.rss'
  end

  def show
    hobo_show do
      render 'show.rss' if request.format.rss?
    end
  end
end