# encoding: utf-8

namespace :value do
  # starten als: 'bundle exec rake value:transfer'
  # in Produktivumgebungen: 'bundle exec rake value:transfer RAILS_ENV=production'
  desc "Transfers values into new structure"
  task :transfer => :environment do

    Product.all.each do |product|
      product.property_groups.each do |property_group|
        @property_group = PropertyGroup.find_or_initialize_by(name_de: property_group.name_de, product_id: nil)
        @property_group.name_en = property_group.name_en if property_group.name_en
        @property_group.position = property_group.position if property_group.position
        @property_group.save

        property_group.properties.each do |property|
          @name_de = property.name_de
          @name_de ||= property.name_en
          @property = Property.find_or_initialize_by(name_de: @name_de, property_group_id: nil)
          @property.name_en = property.name_en if property.name_en
          @datatype = "textual" if property.description_de
          @datatype = "numeric" if property.value
          @property.datatype = @datatype
          @property.position = property.position if property.position
          @property.save
          @value = Value.new(title_de:          property.description_de,
                             title_en:          property.description_en,
                             value:             property.value,
                             unit_de:           property.unit_de,
                             unit_en:           property.unit_en,
                             product_id:        property_group.product_id,
                             property_id:       @property.id,
                             property_group_id: @property_group.id)
          @value.state = @datatype
          @value.save
          property.delete
        end
        property_group.delete
      end
      puts Property.count.to_s
    end
  end

  # starten als: 'bundle exec rake value:find_numerics'
  # in Produktivumgebungen: 'bundle exec rake value:find_numerics RAILS_ENV=production'
  desc "Find numerical values"
  task :find_numerics => :environment do
    Value.where(state: "textual").each do |value|
      @value = nil
      next if value.state != "textual"

      if value.title_de.split(" ").length == 2
        @value = Float value.title_de.split(" ")[0] rescue nil
        @unit = value.title_de.split(" ")[1]
        if @value
          value.value = @value
          value.unit_de = @unit
          value.unit_en = @unit
          value.state = "numeric"
          value.title_de = nil
          value.title_en = nil
          value.save
          print "#"
        end
        next
      end

      @value = Float value.title_de rescue nil
      if @value
        value.value = @value
        value.state = "numeric"
        value.title_de = nil
        value.title_en = nil
        value.save
        print "1"
        next
      end

      if ["No","N"].include?(value.title_de)
        value.flag = false
        value.title_de = nil
        value.title_en = nil
        value.state = "flag"
        value.save
        print "-"
        next
      end

      if ["Yes","Y"].include?(value.title_de)
        value.flag = true
        value.title_de = nil
        value.title_en = nil
        value.state = "flag"
        value.save
        print "+"
        next
      end
    end
  end

  task :count => :environment do
    100.times do
      puts Value.where(state: "textual").count.to_s
      sleep 3
    end
  end
end