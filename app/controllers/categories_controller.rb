class CategoriesController < ApplicationController

  hobo_model_controller
  auto_actions :show

  before_filter :domain_shop_redirect

  def show
    hobo_show do
      @filter = params[:filter]
      @filter ||= {}

      matcharray = []
      @filter.each do |key, value|
        matcharray << { match: { URI.unescape(key) => URI.unescape(value) } }
      end

      @facets = Product.search(query: {
                                 bool: {
                                   must: [ { match: { category_ids: params[:id].to_i } },
                                           { match: { state: 'active' } }
                                         ] + matcharray
                                 }
                               },
                               facets: this.filters.values.flatten)

      @products = Product.search(query: {
                                   bool: {
                                     must: [ { match: { category_ids: params[:id].to_i } },
                                             { match: { state: 'active' } }
                                           ] + matcharray
                                   }
                                 }).results

      if @products.any?
        prices = @products.results.*.determine_price
        @min = prices.min
        @max = prices.max
      end
    end
  end
end