class ContractitemSerializer < ActiveModel::Serializer
  attributes :id, :position, :term, :startdate, :product_number,
             :description_de, :description_en, :amount, :unit, :volume_bw,
             :volume_color, :marge, :vat, :discount_abs, :monitoring_rate,
             :created_at, :updated_at

  has_many :consumableitems
# FIXME!: Fixes stack level too deep
#  has_one :contract
end