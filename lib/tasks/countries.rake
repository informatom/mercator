# encoding: utf-8
require 'csv'

namespace :countries do
  # starten als: 'bundle exec rake countries:import RAILS_ENV=production'
  desc "Import German country names"
  task :import => :environment do

    CSV.foreach(File.path("#{Rails.root}/materials/countries_de.csv")) do |column|
      @country = Country.find_by_code(column[0])
      if @country
        @country.update(name_de: column[1])
      else
        puts column[0] + " nicht gefunden."
      end
    end
  end
end