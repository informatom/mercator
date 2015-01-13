class BlogpostsController < ApplicationController
  hobo_model_controller
  auto_actions :index, :show
  index_action :feed

  before_filter :domain_cms_redirect

  def index
    page = params[:page] ? params[:page].to_i : 1
    self.this = Blogpost.joins(:content_element)
                        .merge(ContentElement.where
                                             .not(ContentElement.current_locale_column(:content) => [nil, ""]))
                        .paginate(page: page)
                        .order('publishing_date DESC')
                        .where.not(publishing_date: nil)
    self.this = self.this.tagged_with(params[:tag]) if params[:tag]
    self.this = self.this.where(post_category_id: params[:post_category_id]) if params[:post_category_id]
    @blogposts= self.this

    if params[:month]
      in_month = params[:month].to_datetime..(params[:month].to_datetime + 1.month)
      self.this = self.this.where(publishing_date: in_month)
    end

    hobo_index
  end

  def feed
    @blogposts = Blogpost.where.not(publishing_date: nil)
  end
end