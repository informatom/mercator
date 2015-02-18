# encoding: utf-8

namespace :export do
  desc "Exports Gtc.all in a seeds.rb way."
  task :gtc_seeds => :environment do
    Gtc.all.each do |gtc|
      puts "Gtc.create(#{gtc.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end

  desc "Exports PageTemplate.all in a seeds.rb way."
  task :page_template_seeds => :environment do
    PageTemplate.all.each do |page_template|
      puts "PageTemplate.create(#{page_template.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end

end