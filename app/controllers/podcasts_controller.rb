class PodcastsController < ApplicationController
  hobo_model_controller
  auto_actions :index, :show

  before_filter :domain_cms_redirect
end