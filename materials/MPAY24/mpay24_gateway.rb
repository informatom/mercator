require 'uri'
require 'cgi'
require 'net/http'
require 'net/https'
require 'rubygems'
require 'active_support'

hash =  {"Tid"=>"200905180719-31", "Price"=>"0.10"}


class Mpay24Gateway
  GATEWAY_URL = "www.mpay24.com"
  ETPV5_PATH = '/app/bin/etpv5'
  HEADERS =  {'Referer' => 'http://iv-shop.at', "Content-Type"=>"application/x-www-form-urlencoded"}
  ETPV5_DATA = {
    'OPERATION' => 'SELECTPAYMENT'
  }

  class GatewayError < Exception
  end

  def initialize( merchant_id, tid, order_xml )
    @merchant_id = merchant_id
    @tid = tid
    @order_xml = order_xml
    #URI.escape(hash.to_xml( :skip_instruct => true, :root => "Order" ), Regexp.new("[^#{URI::PATTERN::UNRESERVED}]" ) )
  end

  def data
    { 'TID' => @tid,
      'MDXI' => @order_xml,
      'MERCHANTID' => @merchant_id }.merge( ETPV5_DATA )
  end

  def get_response
    http = Net::HTTP.new( GATEWAY_URL, 443 )
    http.use_ssl = true
    response, body = http.post( ETPV5_PATH, data.to_query , HEADERS )

    body_params = CGI.parse( body )
    raise Mpay24Gateway::GatewayError, [ body_params['RETURNCODE'], body_params['EXTERNALERROR'] ].join(" : ") if body_params['STATUS'] == ['ERROR']
    body_params
  end
end

# m = Mpay24Gateway.new( '90335', '200905180719-31', hash )
#
# MDXI%5BOrder%5D%5BPrice%5D=0.10&MDXI%5BOrder%5D%5BTid%5D=200905180719-31
# OPERATION=SELECTPAYMENT&MERCHANTID=70015&TID=200905180719%2D30&

#
# MDXI=
# %3COrder%3E%0A%20%3CTid%3E200905180719%2D30%3C%2FTid%3E%0A%20%3CPrice%3E0%2E10%3C%2FPrice%3E%0A%3C%2FOrder%3E
# %3COrder%3E%0A%20%3CTid%3E200905180719  -31%3C%2FTid%3E%0A%20%3CPrice%3E0.10%3C%2FPrice%3E%0A%3C%2FOrder%3E%0A

# %3COrder%3E%0A%20%20%3COrder%3E%0A%20%20%20%20%3CTid%3E200905180719-31%3C%2FTid%3E%0A%20%20%20%20%3CPrice%3E0.10%3C%2FPrice%3E%0A%20%20%3C%2FOrder%3E%0A%3C%2FOrder%3E%0A
#

# OPERATION=SELECTPAYMENT&MERCHANTID=90335&TID=200905180719-31   MDXI%5BOrder%5D%5BPrice%5D=0.10&MDXI%5BOrder%5D%5BTid%5D=200905180719-31