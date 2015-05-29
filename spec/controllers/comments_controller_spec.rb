require 'spec_helper'

describe CommentsController, :type => :controller do
  before :each do
    no_redirects and act_as_user
    @blogpost = create(:blogpost)
    @podcast = create(:podcast)
    @parent_comment_with_podcast = create(:comment, podcast_id: @podcast.id,
                                                    blogpost_id: nil,
                                                    user_id: @user.id)
    @parent_comment_with_blogpost = create(:comment, blogpost_id: @blogpost.id,
                                                     podcast_id: nil,
                                                     user_id: @user.id)
  end


  describe "GET #new" do
    it "sets blogpost if parameter is set" do
      get :new, blogpost_id: @blogpost.id
      expect(assigns(:comment).blogpost_id).to eql @blogpost.id
    end

    it "sets podcast if parameter is set" do
      get :new, podcast_id: @podcast.id
      expect(assigns(:comment).podcast_id).to eql @podcast.id
    end

    it "sets blogpost if comment has parent" do
      get :new, parent_id: @parent_comment_with_podcast
      expect(assigns(:comment).podcast_id).to eql @parent_comment_with_podcast.podcast.id
      expect(assigns(:comment).parent_id).to eql @parent_comment_with_podcast.id
    end

    it "sets podcast if comment has parent" do
      get :new, parent_id: @parent_comment_with_blogpost
      expect(assigns(:comment).blogpost_id).to eql @parent_comment_with_blogpost.blogpost.id
      expect(assigns(:comment).parent_id).to eql @parent_comment_with_blogpost.id
    end

    it "fills blogpost instance variable if associated to blogpost" do
      get :new, blogpost_id: @blogpost.id
      expect(assigns(:blogpost)).to eql assigns(:comment).blogpost
    end

    it "fills podcast instance variable if associated to podcast" do
      get :new, podcast_id: @podcast.id
      expect(assigns(:podcast)).to eql assigns(:comment).podcast
    end
  end
end
