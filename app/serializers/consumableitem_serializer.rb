class ConsumableitemSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :contract_type, :position, :product_number, :product_line,
             :description_de, :description_en, :amount, :theyield, :wholesale_price,
             :term, :consumption1, :consumption2, :consumption3, :consumption4,
             :consumption5, :consumption6, :balance6, :created_at, :updated_at

  has_one :contractitem
end
