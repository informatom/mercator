# encoding: utf-8
require 'faker'

namespace :categories do
  # starten als: 'bundle exec rake categories:fake[42]'
  # in Produktivumgebungen: 'bundle exec rake categories:fake[42] RAILS_ENV=production'
  desc "Create fake Categories"
  task :fake, [:count] => :environment do |t, args|

    Category.delete_all
    Category.create(name: Faker::Commerce.product_name, position: 1)

    args[:count].to_i.times do |i|
      pos = 1 + rand(i - 1).to_i
      parent = Category.find_by_position(pos)
      cat = Category.create(name: Faker::Commerce.product_name, parent_id: parent.id, position: (i + 2) )
    end
  end
end