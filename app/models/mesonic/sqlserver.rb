class Mesonic::Sqlserver < ActiveRecord::Base
  establish_connection :mesonic_cwldaten_development
  self.abstract_class = true

  scope :mesoyear, -> {where(mesoyear: Mesonic::AktMandant.mesoyear)}
  scope :mesocomp, -> {where(mesocomp: Mesonic::AktMandant.mesocomp)}
end