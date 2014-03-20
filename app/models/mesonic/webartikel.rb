class Mesonic::Webartikel < Mesonic::Sqlserver

  self.table_name = "WEBARTIKEL"
  self.primary_key = "Artikelnummer"

  # --- Class Methods --- #

  def self.import
    Mesonic::Webartikel.all.each do |webartikel|
      @product = Product.where(number: webartikel.Artikelnummer).first
      @product = Product.create_in_auto(number: webartikel.Artikelnummer,
                                        title: webartikel.Bezeichnung,
                                        description: webartikel.comment) unless @product

      @inventory = Inventory.new(product_id: @product.id,
                                 number: webartikel.Artikelnummer,
                                 name_de: webartikel.Bezeichnung,
                                 comment_de: webartikel.comment,
                                 weight: webartikel.Gewicht,
                                 charge: webartikel.LfdChargennr,
                                 unit: "Stk.",
                                 delivery_time: webartikel.Zusatzfeld5 || "Auf Anfrage",
                                 amount: 9999,
                                 erp_updated_at: webartikel.letzteAend)

      if @inventory.save
        print "I"
      else
        puts @inventory.errors.first.to_s
      end

      @price =  Price.new(value: webartikel.Preis,
                          scale_from: webartikel.AbMenge,
                          scale_to: 9999,
                          vat: 20,
                          valid_from: Date.today,
                          valid_to: Date.today + 1.year,
                          inventory_id: @inventory.id)

      if @price.save
        print "P"
      else
        puts @price.errors.first.to_s
      end
    end
  end

  # --- Instance Methods --- #

  def comment
    if self.Langtext1.present?
      return self.Langtext1.to_s + " " + self.Langtext2.to_s
    else
      return self.Langtext2.to_s
    end
  end
end