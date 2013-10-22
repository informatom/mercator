require 'will_paginate/array'

class CategoriesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  index_action :treereorder do
    @this = Category.roots.paginate(:page => 1, :per_page => 999)
  end
end