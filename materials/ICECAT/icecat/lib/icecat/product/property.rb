module Icecat
  module Product
    module Property
      def self.included(base)
        base.send( :include, InstanceMethods )
      end
    end


    module InstanceMethods
      def physical_properties
        self.properties.find( :all, :include => :globalize_translations,
          :conditions => ["property_translations.group LIKE ? OR property_translations.group LIKE ?", "%Weight%", "%Gewicht%" ] )
      end
    end

  end
end
