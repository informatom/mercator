require 'net/http'
require 'uri'
require 'zlib'

module Icecat
  class Url2Xml
    
    attr_accessor :username, :password, :xmls
    
    def initialize(conf = {} )
      @password = conf[:password] || "cpP42J"
      @username = conf[:username] || "donrudl"
      @typ = "productxml"
      @vendor = "hp"
      
      @xmls = {} ;
    end
    
    def full_index
      begin
        @url = URI.parse( full_index_url )
        Net::HTTP.start( @url.host, @url.port ) do |http|
          req = ::Net::HTTP::Get.new( "#{@url.path}" )
          req.basic_auth self.username, self.password
          response = http.request( req ) 
          response.value
          response.body
        end
      rescue Exception => e
        return "Error #{e}"
      end
    end
    

    def get(conf = {} )
      @prod_id = conf[:prod_id]
      @lang = conf[:lang]
      @typ ||= conf[:type] 
      @vendor ||= conf[:vendor]
      @xmls[self.url] ||= self.request
    end
  
    def request
      begin
        @url = URI.parse( url )
        Net::HTTP.start( @url.host, @url.port ) do |http|
          req = ::Net::HTTP::Get.new( "#{@url.path}?#{@url.query}" )
          req.basic_auth self.username, self.password
          response = http.request( req )
          response.value
          response.body
        end
        rescue
        return ""
      end
      
    end
    
    def full_index_url
      "http://data.icecat.biz/export/freexml/files.index.xml"
    end
    

    def url
      "http://data.icecat.biz/xml_s3/xml_server3.cgi?prod_id=#{@prod_id};vendor=#{@vendor};lang=#{@lang};output=#{@typ}"
    end
  end
end

