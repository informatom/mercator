class Mesonic::Sqlserver < ActiveRecord::Base

  @const_mesonic = Constant.where(key: "mesonic").first

  if @const_mesonic && @const_mesonic.value == "on"
    establish_connection :mesonic_cwldaten_development
  end
  self.abstract_class = true
end