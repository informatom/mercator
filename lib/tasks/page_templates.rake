# encoding: utf-8

namespace :page_templates do

  # starten als: rake page_templates:save_to_disk RAILS_ENV=production
  desc "Persist page templates to file system"
  task :save_to_disk => :environment do
    page_templates_dir = Rails.root.to_s + "/app/views/page_templates"
    Dir.mkdir(page_templates_dir) unless File.exists?(page_templates_dir)

    PageTemplate.all.each do |page_template|
      page_template.save_to_disk
    end
  end
end