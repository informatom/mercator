class FrontController < ApplicationController

  hobo_controller

  def index; end

  def home
    @home = Webpage.where(slug: "home").first
    if @home
      redirect_to "/home"
    else
      redirect_to action: :index
    end
  end

  def summary
    redirect_to user_login_path unless current_user.administrator?
  end

  def search
    if params[:query]
      @categories = Category.search(params[:query],
                                    where: {state: 'active'},
                                    fields: [:name_de, :name_en, :description_de, :description_en, :long_description_de, :long_description_en])
                            .results.uniq

      @products = Product.search(params[:query],
                                 where: {state: 'active'},
                                 fields: [:title_de, :title_en, :number, :description_de, :description_en, :long_description_de, :long_description_en])
                         .results.uniq

      @search_results = [I18n.t("activerecord.models.category.other")] + @categories +
                        [I18n.t("activerecord.models.product.other")] + @products
      hobo_ajax_response
    end
  end
end