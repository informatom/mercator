require 'rubygems'

class Bechlem::Base < ActiveRecord::Base
  self.abstract_class = true

  def method_missing method_name, *args, &block
    return self.send(method_name.to_s.downcase) if self.respond_to?( method_name.to_s.downcase )
    super
  end
  
  def self.mesonic_connection_environment
    case RAILS_ENV
    when "production" then :production_bechlem
    when "development" then :development_bechlem
    else :development_bechlem
    end
  end
  
  def delete ; end
  def destroy ; end
  
  self.establish_connection mesonic_connection_environment
end
