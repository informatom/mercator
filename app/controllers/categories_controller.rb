class CategoriesController < ApplicationController

  hobo_model_controller
  auto_actions :show

  before_filter :domain_shop_redirect

  def show
    hobo_show do
      category_id = params[:id].to_i
      @min = Category.find(category_id).filtermin
      @max = Category.find(category_id).filtermax

      @filter = params[:filter]
      @filter ||= {}

      matcharray = []
      @filter.each do |key, value|
        matcharray << { match: { URI.unescape(key) => URI.unescape(value) } }
      end

      @facets = Product.search(query: { bool: { must: [ { match: { category_ids: category_id } },
                                              { match: { state: 'active' } } ] + matcharray } },
                               facets: this.filters.values.flatten)

      if params[:pricelow] && params[:pricehigh]
        @products = Product.search(query: { bool: { must: [ { match: { category_ids: category_id } },
                                                            { match: { state: 'active' } },
                                                            { range: { price: { gte: params[:pricelow], lte: params[:pricehigh] } } } ] + matcharray } } ).results

        @minslider, @maxslider = params[:pricelow], params[:pricehigh]
      else
        @products = Product.search(query: { bool: { must: [ { match: { category_ids: category_id } },
                                                            { match: { state: 'active' } } ] + matcharray } } ).results

        @minslider, @maxslider = @min, @max
      end
    end
  end
end