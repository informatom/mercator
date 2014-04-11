module MercatorIcecat
  class Metadata < ActiveRecord::Base

    hobo_model # Don't put anything above this

    fields do
      path              :string
      icecat_updated_at :datetime
      quality           :string
      supplier_id       :string
      icecat_product_id :string
      prod_id           :string
      product_number    :string
      cat_id            :string
      on_market         :string
      model_name        :string
      product_view      :string
      timestamps
    end
    attr_accessible :path, :cat_id, :product_id, :icecat_updated_at, :quality, :supplier_id,
                    :prod_id, :on_market, :model_name, :product_view, :icecat_product_id

    belongs_to :product, :class_name => "Product"

    # --- Permissions --- #

    def create_permitted?
      acting_user.administrator?
    end

    def update_permitted?
      acting_user.administrator?
    end

    def destroy_permitted?
      acting_user.administrator?
    end

    def view_permitted?(field)
      true
    end

    def self.import(full: false, date: Date.today)
      if full
        file = File.open(Rails.root.join("vendor","catalogs","files.index.xml"), "r")
      else
        file = File.open(Rails.root.join("vendor","catalogs",date.to_s + "-index.xml"), "r")
      end

      products = Nokogiri::XML(file).xpath('//ICECAT-interface/files.index/file[@Supplier_id = "1"]') # Hewlett Packard => 1
      products.each do |product|
        metadata = self.find_or_create_by_icecat_product_id(product.attr("Product_ID"))

        if metadata.update(path:              product.attr("path"),
                           cat_id:            product.attr("Catid"),
                           icecat_product_id: product.attr("Product_ID"),
                           icecat_updated_at: product.attr("Updated"),
                           quality:           product.attr("Quality"),
                           supplier_id:       product.attr("Supplier_id"),
                           prod_id:           product.attr("Prod_ID"),
                           on_market:         product.attr("On_Market"),
                           model_name:        product.attr("Model_Name"),
                           product_view:      product.attr("Product_View"))
          ::JobLogger.info("Metadata " +      product.attr("Product_ID") + " saved.")
        else
          ::JobLogger.error("Metadata " + product.attr("Product_ID") + " could not be saved: " + metadata.errors.first )
        end
      end
    end
  end
end