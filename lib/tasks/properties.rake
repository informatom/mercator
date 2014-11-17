# encoding: utf-8
namespace :properties do
  # starten als: 'bundle exec rake properties:dedup
  # in Produktivumgebungen: 'bundle exec rake properties:dedup RAILS_ENV=production'
  desc "deduplicating properties and removing orphans"
  task :dedup => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: properties:dedup")

    orphaned_values = Value.where.not(property_id: Property.pluck(:id)).count
    unless orphaned_values == 0
      JobLogger.fatal("There are " + orphaned_values + " orphaned values.")
      abort("There are " + orphaned_values + " orphaned values. Aborting...")
    end
    JobLogger.info("Curretly we have " + Property.count.to_s + " properties.")

    Property.all.group_by(&:name_de).each do |name, properties|
       we_keep_id = properties.first.id
       properties.shift
       properties.each do |property|
         values_to_move = Value.where(property_id: property.id)
         if values_to_move.update_all(property_id: we_keep_id)
           JobLogger.info("Successfully updated " + values_to_move.count.to_s + " values.")
         else
           JobLogger.fatal("Could not update values! Aborting...")
           abort("Could not update values!")
         end
         JobLogger.info("Deleting Property " + property.id.to_s)
         property.delete
       end
    end

    Property.all.each do |property|
      if property.values.count == 0
        JobLogger.info("Deleting Property " + property.id.to_s)
        property.delete
      end
    end

    JobLogger.info("Now we have " + Property.count.to_s + " properties left.")
    JobLogger.info("Finished Job: properties:dedup")
    JobLogger.info("=" * 50)
  end

  # starten als: 'bundle exec rake properties:fix_position
  # in Produktivumgebungen: 'bundle exec rake properties:fix_position RAILS_ENV=production'
  desc "Fixing the order of properties"
  task :fix_position => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: properties:fix_position")

    Property.order(:position).each_with_index do |property, index|
      property.update(position: index + 1 )
    end

    JobLogger.info("Finished Job: properties:fix_position")
    JobLogger.info("=" * 50)
  end
end
