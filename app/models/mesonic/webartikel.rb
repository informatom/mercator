class Mesonic::Webartikel < Mesonic::Cwl

  def self.table_name
    "WEBARTIKEL"
  end

  set_primary_key "Artikelnummer"
end