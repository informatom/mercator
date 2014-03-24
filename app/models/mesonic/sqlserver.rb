class Mesonic::Sqlserver < ActiveRecord::Base

  @const_mesonic = Constant.where(key: "mesonic").first

  if CONFIG[:mesonic] == "on"
    establish_connection :mesonic_cwldaten_development
  end
  self.abstract_class = true
end