module Icecat
  module Product
    module Image

      def self.included(base)
        base.send( :extend, ClassMethods )
        base.send( :include, InstanceMethods )

        base.class_eval do
          has_attached_file :overview,
            :styles => { :thumb=> "168x132" }, :default_url => "/missing_image/:style"

          has_attached_file :image,
            :styles => {
              :thumb => "98x109!",
              :small  => "150x150>",
              :medium => "300x300>",
              :large =>   "400x400>"
            }, :default_url => "/missing_image/:style"

          attr_accessor :delete_overview_image, :delete_regular_image
          before_save :check_image_deletion
        end
      end

      module ClassMethods
      end

      module InstanceMethods

        def has_overview?
          !self.overview.path.nil?
        end

        def has_image?
          !self.image.path.nil?
        end

        def image(typ)
          if typ == :overview
            self.overview(:thumb).data.url
          else
            self.image( typ ).data.url
          end
        end

        def check_image_deletion
          self.overview = nil if self.delete_overview_image == "1"
          self.image = nil if self.delete_regular_image == "1"
        end
      end
    end
  end
end