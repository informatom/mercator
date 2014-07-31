class ContractSerializer < ActiveModel::Serializer
  self.root = true
  embed :ids

  attributes :id, :term, :startdate, :created_at, :updated_at

  has_many :contractitems
end