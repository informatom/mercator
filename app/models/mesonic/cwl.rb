class Mesonic::Cwl < ActiveRecord::Base
  self.abstract_class = true

  def self.mesonic_connection_environment
    case RAILS_ENV
    when "production"
      :production_mesonic_cwldaten
    when "development"
      :development_mesonic_cwldaten
    when "test"
      :development_mesonic_cwldaten
    end
  end

  self.establish_connection mesonic_connection_environment

  scope :mesoyear, -> {where(mesoyear: Mesonic::AktMandant.mesoyear)}
  scope :mesocomp, -> {where(mesocomp: Mesonic::AktMandant.mesocomp)}
end