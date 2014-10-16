# encoding: utf-8
require 'csv'

namespace :content_elements do
  # starten als: 'bundle exec rake content_elements:put_into_folder'
  # in Produktivumgebungen: 'bundle exec rake content_elements:put_into_folder RAILS_ENV=production'
  desc "Put content_elements in default folder"
  task :put_into_folder => :environment do
    default_folder = Folder.find_by(name: "zuzuordnen")
    ContentElement.where(folder_id: nil).update_all(folder_id: default_folder.id)
  end
end