class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  def exclude?
    bot? || request.ip == "93.189.25.85" # zabbix
  end
end
