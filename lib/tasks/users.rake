# encoding: utf-8

namespace :users do
  # starten als: 'bundle exec rake users:create_defaults RAILS_ENV=production'
  desc "Create default users"
  task :create_defaults => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:create_defaults")

    # one liner for creating a password from the console:
    # user = User.create(first_name: "Stefan", surname: "Haslinger", email_address: "stefan.haslinger@mittenin.at", administrator: true, password: "%PASSWORD%" , password_confirmation: %PASSWORD%, state: "active")

    # ["erster", "zweiter", "dritter", "vierter"].each_with_index do |firstname, index|
    #   unless User.find_by(first_name: firstname)
    #     User.create(first_name: firstname,
    #                 surname: "Vertriebsmitarbeiter",
    #                 email_address: (index + 1).to_s + "@mercator.mittenin.at",
    #                 sales: true,
    #                 password: "123456",
    #                 password_confirmation: "123456",
    #                 state: "active")
    #   end
    # end

    JobLogger.info("Finished Job: categories:create_defaults")
    JobLogger.info("=" * 50)
  end
end