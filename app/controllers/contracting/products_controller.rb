class Contracting::ProductsController < Contracting::ContractingSiteController
  hobo_model_controller

  index_action :grid_index do
    @products = Product.active

    render json: {
      status: "success",
      total: @products.count,
      records: @products.collect {
        |product| {
          recid:               product.id,
          title_de:            product.title_de,
          title_en:            product.title_en,
          number:              product.number,
          alternative_number:  product.alternative_number,
          description_de:      product.description_de,
          description_en:      product.description_en,
          warranty_de:         product.warranty_de,
          warranty_en:         product.warranty_en,
          not_shippable:       product.not_shippable,
          created_at:          product.created_at.utc.to_i*1000,
          updated_at:          product.updated_at.utc.to_i*1000
        }
      }
    }
  end
end