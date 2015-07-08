class CategoriesController < ApplicationController
  before_filter :domain_shop_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions :show, :index


  def show
    hobo_show do
      category_id = params[:id].to_i
      @min = Category.find(category_id).filtermin.round
      @max = (Category.find(category_id).filtermax + 0.5).round

      @filter = params[:filter]
      @filter ||= {}

      matcharray = []
      @filter.each do |key, value|
        matcharray << { match: { URI.unescape(key) => URI.unescape(value) } }
      end

      if params[:pricelow] && params[:pricehigh]
        @facets = Product.search(query: { bool: { must: [ { match: { category_ids: category_id } },
                                                          { match: { state: 'active' } } ,
                                                          { range: { price: { gte: params[:pricelow], lte: params[:pricehigh] } } } ] + matcharray } },
                                 facets: this.filters.values.flatten) if (this.filters && this.filters.any?)

        @products = Product.search(query: { bool: { must: [ { match: { category_ids: category_id } },
                                                            { match: { state: 'active' } },
                                                            { range: { price: { gte: params[:pricelow], lte: params[:pricehigh] } } } ] + matcharray } } ).results

        @minslider = params[:pricelow].to_i
        @maxslider = params[:pricelow] == params[:pricehigh] ? params[:pricehigh].to_i : params[:pricehigh].to_i + 1
      else
        @facets = Product.search(query: { bool: { must: [ { match: { category_ids: category_id } },
                                                { match: { state: 'active' } } ] + matcharray } },
                                 facets: this.filters.values.flatten) if (this.filters && this.filters.any?)

        @products = Product.search(query: { bool: { must: [ { match: { category_ids: category_id } },
                                                            { match: { state: 'active' } } ] + matcharray } } ).results

        @minslider = @min
        @maxslider = @max
      end
      # Ordering:
      @products = Product.where(id: @products.collect(&:id)).includes(:categorizations).order("categorizations.position")
    end
  end


  def index
    self.this = @categories = Category.where(ancestry: nil).active
    hobo_index
  end


  show_action :refresh do
    # params[:id] sends product_id, not category_id, so:
    self.this = @category = Category.find(params[:page_path].split("/")[2].split("-")[0])

    @inventory = Inventory.find(params[:inventory_id]) if params[:inventory_id]
    show_response
  end
end