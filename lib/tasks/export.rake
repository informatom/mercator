# encoding: utf-8

namespace :export do
  # starten als: 'bundle exec rake export:gtc_seeds RAILS_ENV=production'
  desc "Exports Gtc.all in a seeds.rb way."
  task :gtc_seeds => :environment do
    Gtc.all.each do |gtc|
      puts "Gtc.create(#{gtc.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end

  # starten als: 'bundle exec rake export:page_template_seeds RAILS_ENV=production'
  desc "Exports PageTemplate.all in a seeds.rb way."
  task :page_template_seeds => :environment do
    PageTemplate.all.each do |page_template|
      puts "PageTemplate.create(#{page_template.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end

  # starten als: 'bundle exec rake export:shipping_cost_seeds RAILS_ENV=production'
  desc "Exports ShippingCost.all in a seeds.rb way."
  task :shipping_cost_seeds => :environment do
    ShippingCost.all.each do |shipping_cost|
      puts "ShippingCost.create(#{shipping_cost.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end

  # starten als: 'bundle exec rake export:country_seeds RAILS_ENV=production'
  desc "Exports Country.all in a seeds.rb way."
  task :country_seeds => :environment do
    Country.all.each do |country|
      puts "Country.create(#{country.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id', 'legacy_id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end

end