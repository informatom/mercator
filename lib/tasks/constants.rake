# encoding: utf-8

namespace :constants do
  # starten als: 'bundle exec rake constants:create_defaults'
  # in Produktivumgebungen: 'bundle exec rake constants:create_defaults RAILS_ENV=production'
  desc "Create default constants"
  task :create_defaults => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:create_defaults")

    Constant.create(key: :delivery_times_de,     value: "1-2 Tage,2-4 Tage,1 Woche,auf Anfrage") unless Constant.find_by(key: :delivery_times_de)
    Constant.create(key: :delivery_times_en,     value: "1-2 days,2-4 days,1 week,on request")   unless Constant.find_by(key: :delivery_times_en)
    Constant.create(key: :shop_domain,           value: "shop.mydomain")                         unless Constant.find_by(key: :shop_domain)
    Constant.create(key: :cms_domain,            value: "cms.mydomain")                          unless Constant.find_by(key: :cms_domain)
    Constant.create(key: :fifo,                  value: "true")                                  unless Constant.find_by(key: :fifo)
    Constant.create(key: :shipping_cost_article, value: "SHIPPING_COSTS")                        unless Constant.find_by(key: :shipping_cost_article)
    Constant.create(key: :site_name,             value: "My Mercator")                           unless Constant.find_by(key: :site_name)
    Constant.create(key: :service_mail,          value: "no-reply@my-mercator.mydomain")         unless Constant.find_by(key: :service_mail)
    unless Constant.find_by(key: :office_hours)
      Constant.create(key: :office_hours,
                      value: '{MON: ["11:30", "17:00"], TUE: ["8:30", "17:00"], WED: ["8:30", "17:00"], THU: ["8:30", "17:00"], FRI: ["8:30", "12:30"]}')
    end
#   Constant.create(key: , value: "") unless Constant.find_by(key: )

    JobLogger.info("Finished Job: categories:create_defaults")
    JobLogger.info("=" * 50)
  end
end
