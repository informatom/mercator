if CONFIG[:mesonic] == "on"

  class Mesonic::Webartikel < Mesonic::Sqlserver

    self.table_name = "WEBARTIKEL"
    self.primary_key = "Artikelnummer"

    # --- Class Methods --- #

    def self.import(update: "changed")
      @topsellers = Category.topseller
      @novelties  = Category.novelties
      @discounts  = Category.discounts

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

            if @product
              @product.recommendations.destroy_all
              @product.categorizations.where(category_id: @novelties.id).destroy_all
              @product.categorizations.where(category_id: @discounts.id).destroy_all
              @product.categorizations.where(category_id: @topsellers.id).destroy_all
              if @product.lifecycle.can_reactivate?(User.where(administrator: true).first)
                @product.lifecycle.reactivate!(User.where(administrator: true).first)
                puts @product.number + " reactivated"
              end
            else
              @product = Product.create_in_auto(number: webartikel.Artikelnummer,
                                                title: webartikel.Bezeichnung,
                                                description: webartikel.comment)
            end

            webartikel.Zusatzfeld5 ? delivery_time =  webartikel.Zusatzfeld5 : delivery_time = "Auf Anfrage"

            @inventory = Inventory.new(product_id: @product.id,
                                       number: webartikel.Artikelnummer,
                                       name_de: webartikel.Bezeichnung,
                                       comment_de: webartikel.comment,
                                       weight: webartikel.Gewicht,
                                       charge: webartikel.LfdChargennr,
                                       unit: "Stk.",
                                       delivery_time: delivery_time,
                                       amount: 9999,
                                       erp_updated_at: webartikel.letzteAend)

            if webartikel.Kennzeichen = "T"
              @product.topseller = true
              position = 1
              position = @topsellers.categorizations.maximum(:position) + 1 if @topsellers.categorizations.any?
              @product.categorizations.new(category_id: @topsellers.id, position: position)
            end

            if webartikel.Kennzeichen = "N"
              @product.novelty = true
              position = 1
              position = @novelties.categorizations.maximum(:position) + 1 if @novelties.categorizations.any?
              @product.categorizations.new(category_id: @novelties.id, position: position)
            end

            if webartikel.PreisdatumVON && webartikel.PreisdatumVON <= Time.now &&
               webartikel.PreisdatumBIS && webartikel.PreisdatumBIS >= Time.now
              position = 1
              position = @discounts.categorizations.maximum(:position) + 1 if @discounts.categorizations.any?
              @product.categorizations.new(category_id: @discounts.id, position: position)
            end

            if @inventory.save
              print "I"
            else
              puts @inventory.errors.first.to_s
            end

            # ---  Price-Handling --- #
            @price =  Price.new(value: webartikel.Preis,
                                scale_from: webartikel.AbMenge,
                                scale_to: 9999,
                                vat: 20,
                                inventory_id: @inventory.id)

            if webartikel.PreisdatumVON && webartikel.PreisdatumVON <= Time.now &&
               webartikel.PreisdatumBIS && webartikel.PreisdatumBIS >= Time.now
              @price.promotion = true
              @price.valid_from = webartikel.PreisdatumVON
              @price.valid_to = webartikel.PreisdatumBIS
            else
              @price.valid_from = Date.today
              @price.valid_to = Date.today + 1.year
            end

            if @price.save
              print "$"
            else
              puts @price.errors.first.to_s
            end

            # ---  recommendations-Handling --- #
            if webartikel.Notiz1.present? && webartikel.Notiz2.present?
              @recommended_product = Product.where(number: webartikel.Notiz1).first
              @product.recommendations.new(recommended_product: @recommended_product,
                                           reason_de: webartikel.Notiz2) if @recommended_product
            end

            if @product.save
              print "P"
            else
              puts @inventory.errors.first.to_s
            end
          end
        end
      else
        puts "No new entries in WEBARTIKEL View"
      end
    end

    # --- Instance Methods --- #

     def readonly?  # prevents unintentional changes
      true
     end

    def comment
      if self.Langtext1.present?
        return self.Langtext1.to_s + " " + self.Langtext2.to_s
      else
        return self.Langtext2.to_s
      end
    end
  end

end