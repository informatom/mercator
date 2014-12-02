# encoding: utf-8
require 'open-uri'

namespace :users do
  # starten als: 'bundle exec rake users:create_defaults'
  # in Produktivumgebungen: 'bundle exec rake users:create_defaults RAILS_ENV=production'
  desc "Create default users"
  task :create_defaults => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:create_defaults")

    unless User.find_by(surname: "Robot")
      User.create(first_name: "E-Mail",
                  surname: "Robot",
                  email_address: "robot@mercator.mittenin.at",
                  photo: open("#{Rails.root}/materials/images/little-robot.png"),
                  sales: true)
    end

    unless User.find_by(surname: "Job User")
      User.create(first_name: "Mercator",
                  surname: "Job User",
                  email_address: "jobs@mercator.mittenin.at",
                  photo: open("#{Rails.root}/materials/images/little-robot.png"),
                  sales: true)
    end

    ["erster", "zweiter", "dritter", "vierter"].each_with_index do |firstname, index|
      unless User.find_by(first_name: firstname)
        User.create(first_name: firstname,
                    surname: "Vertriebsmitarbeiter",
                    email_address: (index + 1).to_s + "@mercator.mittenin.at",
                    sales: true,
                    password: "123456",
                    password_confirmation: "123456",
                    state: "active")
      end
    end

    JobLogger.info("Finished Job: categories:create_defaults")
    JobLogger.info("=" * 50)
  end
end