class Contracting::ContractitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :index
  respond_to :html, :json

  index_action :manage_contractitems do
    if params[:cmd] == "save-records" && params[:changes]
      params[:changes].each do |key, change|
        contractitem = Contractitem.find(change[:recid])

        unless contractitem.save
          render json: { status: "error", message: contractitem.errors.first } and return
        end
      end
    end

    @contractitems = Contractitem.where(contract_id: params[:contract_id])

    render json: {
      status: "success",
      total: @contractitems.count,
      records: @contractitems.collect {
        |contractitem| {
          recid:           contractitem.id,
          position:        contractitem.position,
          product_number:  contractitem.product_number,
          product_id:      contractitem.product_id,
          toner:           (contractitem.toner.name if contractitem.toner),
          description_de:  contractitem.description_de,
          description_en:  contractitem.description_en,
          amount:          contractitem.amount,
          unit:            contractitem.unit,
          volume:          contractitem.volume,
          product_price:   contractitem.product_price,
          vat:             contractitem.vat,
          value:           contractitem.value,
          discount_abs:    contractitem.discount_abs,
          term:            contractitem.term,
          startdate:       contractitem.startdate,
          volume_bw:       contractitem.volume_bw,
          volume_color:    contractitem.volume_color,
          marge:           contractitem.marge,
          monitoring_rate: contractitem.monitoring_rate,
          created_at:      contractitem.created_at.utc.to_i*1000,
          updated_at:      contractitem.updated_at.utc.to_i*1000
        }
      }
    }
  end
end