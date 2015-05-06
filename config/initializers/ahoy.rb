class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  def exclude?
    bot? || request.ip == "93.189.25.85" # zabbix
  end
end

# Synchronous geocoding resolution creates 1.5 sec  overhead for first request
Ahoy.geocode = false