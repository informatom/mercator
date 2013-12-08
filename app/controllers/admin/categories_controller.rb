require 'will_paginate/array'

class Admin::CategoriesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:name_de_contains]

  index_action :treereorder do
    @this = Category.roots.paginate(:page => 1, :per_page => 999)
  end

  index_action :do_treereorder do
    categories_array = ActiveSupport::JSON.decode(params[:categories])
    parse_categories(categories_array, nil)
    if request.xhr?
      hobo_ajax_response
    end
  end

protected
  def parse_categories(categories_array, parent)
    categories_array.each_with_index do |category_hash, position|
      category = Category.find(category_hash["id"])
      category.update_attributes(position: position, parent_id: parent)
      parse_categories(category_hash["children"], category.id) if category_hash["children"]
    end
  end
end