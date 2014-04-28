class CategoriesController < ApplicationController

  hobo_model_controller
  auto_actions :show

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
                                         ]
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
    end
  end
end