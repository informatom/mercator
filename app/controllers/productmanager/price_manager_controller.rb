class Productmanager::PriceManagerController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index; end

  def manage_product
    product = Product.find(params[:recid])

    respond_to do |format|
      format.html # show.html.erb
      format.text {
        render json: {
          status: "success",
          record: {
            number:              product.number,
            state:               product.state,
            title_de:            product.title_de,
            title_en:            product.title_en,
            description_de:      product.description_de,
            description_en:      product.description_en,
            long_description_de: product.long_description_de,
            long_description_en: product.long_description_en,
            warranty_de:         product.warranty_de,
            warranty_en:         product.warranty_en,
            novelty:             product.novelty,
            topseller:           product.topseller,
            created_at:          I18n.l(product.created_at),
            updated_at:          I18n.l(product.updated_at)
          }
        }
      }
    end
  end
end