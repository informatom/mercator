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

  def show_inventories
    inventories = Inventory.where(product_id: params[:id])

    render json: {
      status: "success",
      total: inventories.count,
      records: inventories.collect {
        |inventory| {
          recid:                   inventory.id,
          name_de:                 inventory.name_de,
          name_en:                 inventory.name_en,
          number:                  inventory.number,
          amount:                  inventory.amount,
          comment_de:              inventory.comment_de,
          comment_en:              inventory.comment_en,
          weight:                  inventory.weight,
          charge:                  inventory.charge,
          storage:                 inventory.storage,
          delivery_time:           inventory.delivery_time,
          erp_updated_at:          I18n.l(inventory.erp_updated_at),
          erp_vatline:             inventory.erp_vatline,
          erp_article_group:       inventory.erp_article_group,
          erp_provision_code:      inventory.erp_provision_code,
          erp_characteristic_flag: inventory.erp_characteristic_flag,
          infinite:                inventory.infinite,
          just_imported:           inventory.just_imported,
          alternative_number:      inventory.alternative_number,
          created_at:              I18n.l(inventory.created_at),
          updated_at:              I18n.l(inventory.updated_at)
        }
      }
    }
  end

  def manage_inventory
    inventory = Inventory.find(params[:recid])

    respond_to do |format|
      format.html # show.html.erb
      format.text {
        render json: {
          status: "success",
          record: {
            recid:                   inventory.id,
            name_de:                 inventory.name_de,
            name_en:                 inventory.name_en,
            number:                  inventory.number,
            amount:                  inventory.amount,
            comment_de:              inventory.comment_de,
            comment_en:              inventory.comment_en,
            weight:                  inventory.weight,
            charge:                  inventory.charge,
            storage:                 inventory.storage,
            delivery_time:           inventory.delivery_time,
            erp_updated_at:          I18n.l(inventory.erp_updated_at),
            erp_vatline:             inventory.erp_vatline,
            erp_article_group:       inventory.erp_article_group,
            erp_provision_code:      inventory.erp_provision_code,
            erp_characteristic_flag: inventory.erp_characteristic_flag,
            infinite:                inventory.infinite,
            just_imported:           inventory.just_imported,
            alternative_number:      inventory.alternative_number,
            created_at:              I18n.l(inventory.created_at),
            updated_at:              I18n.l(inventory.updated_at)
          }
        }
      }
    end
  end
end