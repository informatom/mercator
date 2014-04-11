module Icecat
  class Index
    attr_accessor :xml

    def initialize(xml_io)
      @xml = LibXML::XML::Document.io( xml_io )
    end

    def product_xml_filename( prod_id )
      result = @xml.find("//file[@Prod_ID='#{prod_id}']")
      return nil if result.empty?
      result.first.attributes["path"]
    end
  end
end