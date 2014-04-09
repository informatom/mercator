require 'open-uri'

module Icecat
  class Access

    class << self ;
      def user ; "donrudl" ; end
      def password ; "cpP42J" ; end
      def vendor ; "HP" ; end
      def lang ; "int" ; end
      def typ ; "productxml" ; end
      def gzip ; true ; end
      def unzip ; true ; end
      def base_uri
        "http://data.icecat.biz"
      end
    end

    attr_accessor :user, :password, :vendor, :typ, :lang

    def initialize( conf = {} )
      self.user = conf[:user] || self.class.user
      self.password = conf[:password] || self.class.password
    end

    # returns the full icecat index as IO
    def full_index
      tmp = open( full_index_url, self.class.gzip ? open_uri_options.merge( { "Accept-Encoding" => "gzip" } ) : open_uri_options )
      self.class.gzip && self.class.unzip ? deflate( tmp ) : tmp
    end

    def daily_index
      tmp = open( daily_index_url, self.class.gzip ? open_uri_options.merge( { "Accept-Encoding" => "gzip" } ) : open_uri_options )
      self.class.gzip && self.class.unzip ? deflate( tmp ) : tmp
    end

    def daily_index_url
      self.base_uri + "/export/freexml/daily.index.xml"
    end

    def product_uri( path )
      puts path
      open( "#{self.base_uri}/#{path}", open_uri_options )
    end

    # returns the product xml as IO
    def product( product_id, conf = {} )
      @prod_id = product_id
      @vendor = conf[:vendor] || self.class.vendor
      @lang = conf[:lang] || self.class.lang
      @typ    = conf[:typ]  || self.class.typ
      open( product_url, open_uri_options ).read
    end

    def open_uri_options
      { :http_basic_authentication => [ self.user, self.password ] }
    end

    def deflate(s)
      Zlib::GzipReader.new( s )
    end

    def full_index_url
      self.base_uri + "/export/freexml/files.index.xml"
    end

    def base_uri
      self.class.base_uri
    end

    def product_url
      self.base_uri + "/xml_s3/xml_server3.cgi?prod_id=#{@prod_id};vendor=#{@vendor};lang=#{@lang};output=#{@typ}"
    end
  end
end