# encoding: utf-8
namespace :property_groups do
  # starten als: 'bundle exec rake property_groups:dedup
  # in Produktivumgebungen: 'bundle exec rake property_groups:dedup RAILS_ENV=production'
  desc "Deduplicating property groups and removing orphans"
  task :dedup => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: property_groups:dedup")

    orphaned_values = Value.where.not(property_group_id: PropertyGroup.pluck(:id)).count
    unless orphaned_values == 0
      JobLogger.fatal("There are " + orphaned_values + " orphaned values.")
      abort("There are " + orphaned_values + " orphaned values. Aborting...")
    end
    JobLogger.info("Curretly we have " + PropertyGroup.count.to_s + " property_groups.")

    PropertyGroup.all.group_by(&:name_de).each do |name, property_groups|
       we_keep_id = property_groups.first.id
       property_groups.shift
       property_groups.each do |property_group|
         values_to_move = Value.where(property_group_id: property_group.id)
         if values_to_move.update_all(property_group_id: we_keep_id)
           JobLogger.info("Successfully updated " + values_to_move.count.to_s + " values.")
         else
           JobLogger.fatal("Could not update values! Aborting...")
           abort("Could not update values!")
         end
         JobLogger.info("Deleting PropertyGroup " + property_group.id.to_s)
         property_group.delete
       end
    end

    PropertyGroup.all.each do |property_group|
      if property_group.values.count == 0
        JobLogger.info("Deleting PropertyGroup " + property_group.id.to_s)
        property_group.delete
      end
    end

    JobLogger.info("Now we have " + PropertyGroup.count.to_s + " property_groups left.")
    JobLogger.info("Finished Job: property_groups:dedup")
    JobLogger.info("=" * 50)
  end
end
