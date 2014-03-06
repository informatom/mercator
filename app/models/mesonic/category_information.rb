require 'iconv'

class Mesonic::CategoryInformation < Mesonic::Web

  self.table_name = "WT015"
  set_primary_key :MESOKEY

  def info
    File.open("#{RAILS_ROOT}/tmp/tmp.txt", "w") { |f| f.puts self.C010 }
    sh = `rtf2text #{RAILS_ROOT}/tmp/tmp.txt`
    sh ? Iconv.iconv("UTF-8", "LATIN1", sh ).join(" ") : ""
  end

  def pic
    self.C009
  end
end