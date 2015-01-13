class CommentsController < ApplicationController
  hobo_model_controller
  auto_actions :new, :create

  before_filter :domain_cms_redirect

  def new
    @comment = self.this = Comment.new()

    self.this.user_id = current_user.id
    if params[:blogpost_id]
      @blogpost = Blogpost.find(params[:blogpost_id])
      self.this.blogpost_id = @blogpost.id
    end
    if params[:podcast_id]
      @podcast = Podcast.find(params[:podcast_id])
      self.this.podcast_id = @podcast.id
    end

    if params[:parent_id]

      @parent = Comment.find(params[:parent_id])
      @comment.parent_id = @parent.id

      @comment.blogpost_id = @parent.blogpost_id
      @comment.podcast_id = @parent.podcast_id

      @blogpost = Blogpost.find(@parent.blogpost_id) if @parent.blogpost_id
      @podcast = Podcast.find(@parent.podcast_id) if @parent.podcast_id
    end

    hobo_new
  end

  def create
    @redirect_path = blogpost_path(params[:comment][:blogpost_id]) if params[:comment][:blogpost_id]
    @redirect_path = podcast_path(params[:comment][:podcast_id]) if params[:comment][:podcast_id]

    hobo_create(redirect: @redirect_path) do
      if self.this.valid?
        UserMailer.new_comment(self.this).deliver
      end
    end
  end
end