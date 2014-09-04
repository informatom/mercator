# encoding: utf-8
require 'open-uri'

namespace :users do
  # starten als: 'bundle exec rake users:create_default_users'
  # in Produktivumgebungen: 'bundle exec rake users:create_default_users RAILS_ENV=production'
  desc "Create default users"
  task :create_default_users => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:create_default_users")

    unless User.find_by(surname: "Robot")
      User.create(first_name: "E-Mail",
                  surname: "Robot",
                  email_address: "robot@mercator.mittenin.at",
                  photo: open("#{Rails.root}/materials/images/little-robot.png"),
                  sales: true)
    end

    JobLogger.info("Finished Job: categories:create_default_users")
    JobLogger.info("=" * 50)
  end
end