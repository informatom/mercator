class Mesonic::Webartikel < Mesonic::Sqlserver

  self.table_name = "WEBARTIKEL"
  self.primary_key = "Artikelnummer"

  # --- Class Methods --- #

  def self.import(update: "changed")
    if update == "changed"
      @last_batch = Inventory.maximum(:erp_updated_at)
      @webartikel = Mesonic::Webartikel.where("letzteAend > ?", @last_batch)
    else
      @webartikel = Mesonic::Webartikel.all
    end
    if @webartikel.any?
      @webartikel.group_by{|webartikel| webartikel.Artikelnummer }.each do |artikelnummer, artikel|
        Inventory.where(number: artikelnummer).destroy_all # This also deletes the prices!
        artikel.each do |webartikel|
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

          if webartikel.Kennzeichen = "T"
            @product.topseller = true
            @topsellers = Category.where(name_de: "Topseller").first
            if @topsellers.categorizations.any?
              position = @topsellers.categorizations.maximum(:position) + 1
            else
              position = 1
            end
            @product.categorizations.new(category_id: @topsellers.id,
                                         position: position)
            @product.save
          end

          if webartikel.Kennzeichen = "N"
            @product.novelty = true
            @novelties = Category.where(name_de: "Neuheiten").first
            if @novelties.categorizations.any?
              position = @novelties.categorizations.maximum(:position) + 1
            else
              position = 1
            end

            @product.categorizations.new(category_id: @novelties.id,
                                         position: position)
            @product.save
          end

          if webartikel.PreisdatumVON &&
             webartikel.PreisdatumVON <= Time.now &&
             webartikel.PreisdatumBIS &&
             webartikel.PreisdatumBIS >= Time.now
            @discounts = Category.where(name_de: "Aktionen").first
            if @discounts.categorizations.any?
              position = @discounts.categorizations.maximum(:position) + 1
            else
              position = 1
            end

            @product.categorizations.new(category_id: @discounts.id,
                                         position: position)
            @product.save
          end


          if @inventory.save
            print "I"
          else
            puts @inventory.errors.first.to_s
          end

          @price =  Price.new(value: webartikel.Preis,
                              scale_from: webartikel.AbMenge,
                              scale_to: 9999,
                              vat: 20,
                              inventory_id: @inventory.id)

          if webartikel.PreisdatumVON &&
             webartikel.PreisdatumVON <= Time.now &&
             webartikel.PreisdatumBIS &&
             webartikel.PreisdatumBIS >= Time.now
            @price.promotion = true
            @price.valid_from = webartikel.PreisdatumVON
            @price.valid_to = webartikel.PreisdatumBIS
          else
            @price.valid_from = Date.today
            @price.valid_to = Date.today + 1.year
          end

          if @price.save
            print "P"
          else
            puts @price.errors.first.to_s
          end
        end
      end
    else
      puts "No new entries in WEBARTIKEL View"
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