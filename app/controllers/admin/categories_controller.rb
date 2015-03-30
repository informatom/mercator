require 'will_paginate/array'

class Admin::CategoriesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all
  index_action :deprecate

  autocomplete :name, :query_scope => [:name_de_contains]

  index_action :treereorder do
    @this = @categories = Category.roots.paginate(:page => 1, :per_page => Category.count)
    @categoriesarray = childrenarray(categories: Category.arrange).to_json
  end


  show_action :edit_properties do
    @this = Category.includes(:products, :values, :properties).find(params[:id])
    properties = @this.products.*.values.flatten.*.property.uniq
    properties.sort! { |a,b| a.name <=> b.name }
    @filterable_properties = properties.select { |property| property.state == "filterable"}
    @unfilterable_properties = properties.select { |property| property.state == "unfilterable"}
  end


  index_action :do_treereorder do
    @categories = Category.all
    parse_categories(categories: params[:categories], parent_id: nil)
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
                          .order_by(parse_sort_param(:name_de, :name_en, :this, :description_de, :description_en, :state, :name => "name_de"))
    else
      self.this = Category.paginate(:page => params[:page])
                          .order_by(parse_sort_param(:name_de, :name_en, :this, :description_de, :description_en, :state, :name => "name_de"))
    end
    hobo_index
  end


  def new
    if request_param(:product_manager)
      @cancelpath = productmanager_front_path(category_id: params[:id])
    end
    hobo_new
  end


  def edit
    if request_param(:product_manager)
      @cancelpath = productmanager_front_path(category_id: params[:id])
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


  def deprecate
    JobLogger.info("=" * 50)
    JobLogger.info("Started Task: products:deprecate_categories")
    Category.deprecate
    JobLogger.info("Finished Task: products:deprecate_categories")
    JobLogger.info("=" * 50)
    redirect_to admin_logentries_path
  end


protected
  def parse_categories(categories: nil, parent_id: nil)
    categories.each do |position, categories|
      category = @categories.find(categories["key"])
      if category.position != position.to_i || category.parent_id != parent_id
        category.update(position: position, parent_id: parent_id)
      end
      parse_categories(categories: categories["children"], parent_id: category.id) if categories["children"]
    end
  end


  def childrenarray(categories: nil)
    childrenarray = []
    categories.each do |category, children|
      childhash = Hash["title"  => category.name, "key" => category.id, "folder" => true]
      if children.any?
        childhash["children"] = childrenarray(categories: children)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end
