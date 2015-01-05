class BlogpostsController < ApplicationController
  hobo_model_controller
  auto_actions :index, :show

  before_filter :domain_cms_redirect

  def index
    self.this = @blogposts = Blogpost.paginate(page: params[:page]).order('created_at DESC')
    self.this = self.this.tagged_with(params[:tag]) if params[:tag]
    self.this = self.this.where(post_category_id: params[:post_category_id]) if params[:post_category_id]

    if params[:month]
      in_month = params[:month].to_datetime..(params[:month].to_datetime + 1.month)
      self.this = self.this.where(publishing_date: in_month)
    end
    hobo_index
  end
end