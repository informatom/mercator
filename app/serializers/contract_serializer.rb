class ContractSerializer < ActiveModel::Serializer
  attributes :id, :term, :startdate, :created_at, :updated_at

  has_many :contractitems
end