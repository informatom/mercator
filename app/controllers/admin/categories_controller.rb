require 'will_paginate/array'

class Admin::CategoriesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:name_de_contains]


  def index
    if params[:search]
      @search = params[:search].split(" ").map{|word| "%" + word + "%"}
      self.this = Category.paginate(:page => params[:page])
                          .where{(name_de.matches_any my{@search}) |
                                 (name_en.matches_any my{@search}) |
                                 (description_de.matches_any my{@search}) |
                                 (description_en.matches_any my{@search}) |
                                 (state.matches_any my{@search}) }
                          .order_by(parse_sort_param(:name_de, :name_en, :this, :description_de, :description_en, :state, :name => "name_de"))
    else
      self.this = Category.paginate(:page => params[:page])
                          .order_by(parse_sort_param(:name_de, :name_en, :this, :description_de, :description_en, :state, :name => "name_de"))
    end
    @categories = self.this
    hobo_index
  end


  def edit
    if request_param(:product_manager)
      @cancelpath = productmanager_front_path(category_id: params[:id].to_i)
    end
    hobo_edit
  end


  def update
    if product_id = page_path_param(:product_manager)
      hobo_update(redirect: productmanager_front_path(category_id: params[:id].to_i))
    else
      hobo_update
    end
  end


  show_action :edit_properties do
    self.this = @category = Category.includes(:products, :values, :properties).find(params[:id])
    properties = @category.products.*.values.flatten.*.property.uniq
    properties.sort! { |a,b| a.name <=> b.name }
    @filterable_properties = properties.select { |property| property.state == "filterable"}
    @unfilterable_properties = properties.select { |property| property.state == "unfilterable"}
  end


  index_action :deprecate do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Task: products:deprecate_categories")
    Category.deprecate
    JobLogger.info("Finished Task: products:deprecate_categories")
    JobLogger.info("=" * 50)

    redirect_to admin_logentries_path
  end


  index_action :reindex do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Task: categories:reindex")
    Category.reindex
    JobLogger.info("Finished Task: categories:reindex")
    JobLogger.info("=" * 50)

    redirect_to admin_logentries_path
  end
end