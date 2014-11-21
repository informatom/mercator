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
          unit:                    inventory.unit,
          comment_de:              inventory.comment_de,
          comment_en:              inventory.comment_en,
          weight:                  inventory.weight,
          charge:                  inventory.charge,
          storage:                 inventory.storage,
          delivery_time:           inventory.delivery_time,
          erp_updated_at:          (I18n.l(inventory.erp_updated_at) if inventory.erp_updated_at),
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
    if params[:recid] == "0"
      inventory = Inventory.new
    else
      inventory = Inventory.find(params[:recid])
    end

    if params[:cmd] == "save-record"
      attrs = params[:record]

      infinite = nil
      infinite = true  if attrs[:infinite] == "1"
      infinite = false if attrs[:infinite] == "0"

      inventory.name_de            = attrs[:name_de]
      inventory.name_en            = attrs[:name_en]
      inventory.number             = attrs[:number]
      inventory.amount             = attrs[:amount]
      inventory.unit               = attrs[:unit]
      inventory.comment_de         = attrs[:comment_de]
      inventory.comment_en         = attrs[:comment_en]
      inventory.weight             = attrs[:weight]
      inventory.charge             = attrs[:charge]
      inventory.storage            = attrs[:storage]
      inventory.delivery_time      = attrs[:delivery_time][:text]
      inventory.infinite           = infinite
      inventory.alternative_number = attrs[:alternative_number]
      inventory.product_id         = attrs[:product_id]

      success = inventory.save
    end

    if success == false
      render json: { status: "error",
                     message: inventory.errors.first }
    else
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
              unit:                    inventory.unit,
              comment_de:              inventory.comment_de,
              comment_en:              inventory.comment_en,
              weight:                  inventory.weight,
              charge:                  inventory.charge,
              storage:                 inventory.storage,
              delivery_time:           inventory.delivery_time,
              erp_updated_at:          (I18n.l(inventory.erp_updated_at) if inventory.erp_updated_at),
              erp_vatline:             inventory.erp_vatline,
              erp_article_group:       inventory.erp_article_group,
              erp_provision_code:      inventory.erp_provision_code,
              erp_characteristic_flag: inventory.erp_characteristic_flag,
              infinite:                inventory.infinite,
              just_imported:           inventory.just_imported,
              alternative_number:      inventory.alternative_number,
              created_at:              I18n.l(inventory.created_at),
              updated_at:              I18n.l(inventory.updated_at),
              product_id:              inventory.product_id
            }
          }
        }
      end
    end
  end

  def show_prices
    prices = Price.where(inventory_id: params[:id])

    render json: {
      status: "success",
      total: prices.count,
      records: prices.collect {
        |price| {
          recid:      price.id,
          value:      price.value,
          vat:        price.vat,
          valid_from: I18n.l(price.valid_from),
          valid_to:   I18n.l(price.valid_to),
          scale_from: price.scale_from,
          scale_to:   price.scale_to,
          promotion:  price.promotion,
          created_at: I18n.l(price.created_at),
          updated_at: I18n.l(price.updated_at)
        }
      }
    }
  end

  def manage_price
    if params[:recid] == "0"
      price = Price.new
    else
      price = Price.find(params[:recid])
    end

    if params[:cmd] == "save-record"
      attrs = params[:record]

      promotion = nil
      promotion = true if attrs[:promotion] == "1"
      promotion = false if attrs[:promotion] == "0"

      price.value        = attrs[:value]
      price.vat          = attrs[:vat]
      price.vat          = attrs[:vat]
      price.valid_from   = attrs[:valid_from]
      price.valid_to     = attrs[:valid_to]
      price.scale_from   = attrs[:scale_from]
      price.scale_to     = attrs[:scale_to]
      price.promotion    = promotion
      price.inventory_id = attrs[:inventory_id]

      success = price.save
    end

    if success == false
      render json: { status: "error",
                     message: price.errors.first }
    else
      respond_to do |format|
        format.html # show.html.erb
        format.text {
          render json: {
            status: "success",
            record: {
              recid:        price.id,
              value:        price.value,
              vat:          price.vat,
              valid_from:   (I18n.l(price.valid_from) if price.valid_from),
              valid_to:     (I18n.l(price.valid_to) if price.valid_to),
              scale_from:   price.scale_from,
              scale_to:     price.scale_to,
              promotion:    price.promotion,
              created_at:   I18n.l(price.created_at),
              updated_at:   I18n.l(price.updated_at),
              inventory_id: price.inventory_id
            }
          }
        }
      end
    end
  end

  def delete_price
    price = Price.find(params[:id])
    if price.delete
      render nothing: true
    else
      render json: price.errors.first
    end
  end

  def delete_inventory
    inventory = Inventory.find(params[:id])
    if inventory.prices.any?
      render :text => I18n.t("mercator.price_manager.cannot_delete_inventory.prices"),
             :status => 403 and return
    end

    if inventory.delete
      render nothing: true
    else
      render json: inventory.errors.first
    end
  end
end