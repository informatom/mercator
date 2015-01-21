class Productmanager::RelationManagerController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index
    @product = Product.find(params[:id])
  end

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
          state: [I18n.t('mercator.states.' + product.state)],
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

  def manage_recommendations
    if params[:cmd] == "save-records"
      params[:changes].each do |key, change|
        recommendation = Recommendation.find(change[:recid])

        recommendation.reason_de = change[:reason_de] if change[:reason_de]
        recommendation.reason_en = change[:reason_en] if change[:reason_en]

        unless recommendation.save
         render json: {
           status: "error",
           message: recommendation.errors.first
           } and return
        end
      end
    end

    recommendations = Product.find(params[:id]).recommendations
    render json: {
      status: "success",
      total: recommendations.count,
      records: recommendations.collect {
        |recommendation| {
          recid: recommendation.id,
          supply_number: recommendation.recommended_product.number,
          reason_de: recommendation.reason_de,
          reason_en: recommendation.reason_en,
          created_at: recommendation.created_at.utc.to_i*1000,
          updated_at: recommendation.updated_at.utc.to_i*1000
        }
      }
    }
  end

  def create_recommendation
    if Recommendation.where(product_id:             params[:record][:product_id],
                            recommended_product_id: params[:record][:recommended_product_id]).any?
      render json: { status: "error",
                     message: I18n.t("mercator.recommendation_exists") } and return
    else
      recommendation = Recommendation.new
    end

    attrs = params[:record]
    recommendation.product_id             = attrs[:product_id]
    recommendation.recommended_product_id = attrs[:recommended_product_id]
    recommendation.reason_de              = attrs[:reason_de]
    recommendation.reason_en              = attrs[:reason_en]

    if recommendation.save
      render json: { status: "success" }
    else
      render json: { status: "error",
                     message: recommendation.errors.first }
    end
  end

  def delete_recommendation
    recommendation = Recommendation.find(params[:id])
    if recommendation.delete
      render nothing: true
    else
      render json: recommendation.errors.first
    end
  end

  def show_categorizations
    categorizations = Product.find(params[:id]).categorizations
    render json: {
      status: "success",
      total: categorizations.count,
      records: categorizations.collect {
        |categorization| {
          recid: categorization.id,
          category_name:   categorization.category.name,
          ancestor_string: categorization.category.ancestor_string,
          position:        categorization.position,
          created_at:      categorization.created_at.utc.to_i*1000,
          updated_at:      categorization.updated_at.utc.to_i*1000
        }
      }
    }
  end

  def show_categorytree
    render json: childrenarray(objects: Category.arrange(order: :position),
                               name_method: :name_with_status).to_json
  end

  def add_categorization
    if Categorization.where(category_id: params[:category_id],
                            product_id:  params[:product_id]).any?
      render json: { status: "error",
                     message: I18n.t("mercator.relation_manager.categorization_exists") } and return
    end

    categorization = Categorization.new(position:    1,
                                        category_id: params[:category_id],
                                        product_id:  params[:product_id] )
    if categorization.save
      render nothing: true
    else
      render json: { status: "error",
                     message: categorization.errors.first }
    end
  end

  def delete_categorization
    categorization = Categorization.find(params[:id])
    if categorization.delete
      render nothing: true
    else
      render json: categorization.errors.first
    end
  end

protected

  def childrenarray(objects: nil, name_method: nil, folder: false)
    childrenarray = []
    objects.each do |object, children|
      childhash = Hash["title"  => object.send(name_method), "key" => object.id, "folder" => folder]
      if children.any?
        childhash["children"] = childrenarray(objects: children,
                                              name_method: name_method,
                                              folder: folder)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end