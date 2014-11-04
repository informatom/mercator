class Productmanager::FrontController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js

  def index; end

  def show_categorytree
    render json: childrenarray(objects: Category.arrange(order: :position),
                               name_method: :name_with_status).to_json
  end

  def show_products
    category = Category.find(params[:id])

    products = category.products
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
          novelty: product.novelty,
          topseller: product.topseller,
          created_at: product.created_at.utc.to_i*1000,
          updated_at: product.updated_at.utc.to_i*1000
        }
      }
    }
  end

protected

  def childrenarray(objects: nil, name_method: nil, folder: false)
    childrenarray = []
    objects.each do |object, children|
      childhash = Hash["title"  => object.send(name_method), "key" => object.id, "folder" => folder]
      if children.any?
        childhash["children"] = childrenarray(objects: children, name_method: name_method, folder: folder)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end