class Productmanager::RelationManagerController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index; end

  def show_products
    products = Product.all

    render json: {
      status: "success",
      total: products.count,
      records: products.collect {
        |product| {
          recid: product.id,
          number: product.number,
          title_de: product.title_de,
          title_en: product.title_en,
          description_de: product.description_de,
          description_en: product.description_en,
          long_description_de: ActionController::Base.helpers.strip_tags(product.long_description_de),
          long_description_en: ActionController::Base.helpers.strip_tags(product.long_description_en),
          warranty_de: product.warranty_de,
          warranty_en: product.warranty_en,
          state: I18n.t('mercator.states.' + product.state),
          novelty: product.novelty,
          topseller: product.topseller,
          created_at: product.created_at.utc.to_i*1000,
          updated_at: product.updated_at.utc.to_i*1000
        }
      }
    }
  end

  def show_productrelations
    productrelations = Product.find(params[:id]).productrelations
    render json: {
      status: "success",
      total: productrelations.count,
      records: productrelations.collect {
        |productrelation| {
          recid: productrelation.id,
          related_product_number: productrelation.related_product.number,
          created_at: productrelation.created_at.utc.to_i*1000,
          updated_at: productrelation.updated_at.utc.to_i*1000
        }
      }
    }
  end

  def create_productrelation
    productrelation = Productrelation.new(product_id:         params[:product_id],
                                          related_product_id: params[:related_product_id])

    if productrelation.save
      render nothing: true
    else
      render json: { status: "error",
                     message: productrelation.errors.first }
    end
  end

  def delete_productrelation
    productrelation = Productrelation.find(params[:id])
    if productrelation.delete
      render nothing: true
    else
      render json: productrelation.errors.first
    end
  end

  def show_supplyrelations
    supplyrelations = Product.find(params[:id]).supplyrelations
    render json: {
      status: "success",
      total: supplyrelations.count,
      records: supplyrelations.collect {
        |supplyrelation| {
          recid: supplyrelation.id,
          supply_number: supplyrelation.supply.number,
          created_at: supplyrelation.created_at.utc.to_i*1000,
          updated_at: supplyrelation.updated_at.utc.to_i*1000
        }
      }
    }
  end

  def create_supplyrelation
    supplyrelation = Supplyrelation.new(product_id: params[:product_id],
                                        supply_id:  params[:supply_id])

    if supplyrelation.save
      render nothing: true
    else
      render json: { status: "error",
                     message: supplyrelation.errors.first }
    end
  end

  def delete_supplyrelation
    supplyrelation = Supplyrelation.find(params[:id])
    if supplyrelation.delete
      render nothing: true
    else
      render json: supplyrelation.errors.first
    end
  end
end