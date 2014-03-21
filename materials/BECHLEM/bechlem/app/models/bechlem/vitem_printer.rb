class Bechlem::VitemPrinter < Bechlem::Base
  def self.table_name ; :item_printer_temp ; end
  set_primary_key 'IDITEM'
end