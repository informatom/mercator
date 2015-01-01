class BlogpostsController < ApplicationController
  hobo_model_controller
  auto_actions :index

  before_filter :domain_cms_redirect
end