class FrontController < ApplicationController

  hobo_controller

  def index
  end

  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      @products = Product.search(params[:query],
                                 where: {state: 'active'},
                                 fields: [:title_de, :title_en, :number, :description_de, :description_en, :long_description_de, :long_description_en]).results.uniq
      # categories: set_search_columns :name_de, :name_en, :description_de, :description_en, :long_description_de, :long_description_en
      @search_results = @products
      hobo_ajax_response
    end
  end

end
