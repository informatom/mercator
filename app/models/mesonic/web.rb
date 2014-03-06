class Mesonic::Web < ActiveRecord::Base
  self.abstract_class = true

  def self.mesonic_connection_environment
    case RAILS_ENV
    when "production"
      :production_mesonic_webedition
    when "development"
      :development_mesonic_webedition
    when "test"
      :development_mesonic_webedition
    end
  end

  self.establish_connection mesonic_connection_environment
end