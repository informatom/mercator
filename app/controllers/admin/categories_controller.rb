require 'will_paginate/array'

class Admin::CategoriesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:name_de_contains]

  index_action :treereorder do
    @this = Category.roots.paginate(:page => 1, :per_page => Category.count)
  end

  show_action :edit_properties do
    @this = Category.find(params[:id])
    properties = @this.products.*.values.flatten.*.property.uniq
    @count = properties.count
    @filterable_properties = properties.select { |property| property.state == "filterable"}
    @unfilterable_properties = properties.select { |property| property.state == "unfilterable"}
  end

  index_action :do_treereorder do
    categories_array = ActiveSupport::JSON.decode(params[:categories])
    @categories = Category.all
    @properties = []
    parse_categories(categories_array, nil)
    if request.xhr?
      hobo_ajax_response
    end
  end

  def index
    if params[:search]
      @search = params[:search].split(" ").map{|word| "%" + word + "%"}
      self.this = Category.paginate(:page => params[:page])
                          .where{(name_de.matches_any my{@search}) |
                                 (name_en.matches_any my{@search}) |
                                 (description_de.matches_any my{@search}) |
                                 (description_en.matches_any my{@search}) |
                                 (state.matches_any my{@search}) }
                          .order_by(parse_sort_param(:name_de, :name_en, :this))
    else
      self.this = Category.paginate(:page => params[:page])
                          .order_by(parse_sort_param(:name_de, :name_en, :this))
    end
    hobo_index
  end

protected

  def parse_categories(categories_array, parent)
    categories_array.each_with_index do |category_hash, position|
      category = @categories.find(category_hash["id"])
      if category.position.to_i != position || category.parent_id != parent
        category.update(position: position, parent_id: parent)
      end
      parse_categories(category_hash["children"], category.id) if category_hash["children"]
    end
  end
end