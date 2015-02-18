### Constants ###

# Site name
Constant.find_or_create_by(key: :site_name) do |constant|
  constant.value= "My Mercator"
end

# delivery times, in german, comma seperated
Constant.find_or_create_by(key: :delivery_times_de) do |constant|
  constant.value = "1-2 Tage,2-4 Tage,1 Woche,auf Anfrage"
end

# delivery times, comma seperated
Constant.find_or_create_by(key: :delivery_times_en) do |constant|
  constant.value= "1-2 days,2-4 days,1 week,on request"
end

# Domain used for web shop and consulting part of mercator
Constant.find_or_create_by(key: :shop_domain) do |constant|
  constant.value = "shop.mydomain"
end

# Domain used for CMS part of mercator
Constant.find_or_create_by(key: :cms_domain) do |constant|
  constant.value = "cms.mydomain"
end

# store strategy / policy: "true" of "false"
Constant.find_or_create_by(key: :fifo) do |constant|
  constant.value = "true"
end

# article name for shipping_casts
Constant.find_or_create_by(key: :shipping_cost_article) do |constant|
  constant.value = "SHIPPING_COSTS"
end

# E-mail address for service ("office") mails
Constant.find_or_create_by(key: :service_mail) do |constant|
  constant.value= "no-reply@my-mercator.mydomain"
end

# Office hours, hash of array values, be careful with the quotes!
# Example: '{MON: ["11:30", "17:00"], TUE: ["8:30", "17:00"], WED: ["8:30", "17:00"], THU: ["8:30", "17:00"], FRI: ["8:30", "12:30"]}'
Constant.find_or_create_by(key: :office_hours) do |constant|
  constant.value = '{MON: ["11:30", "17:00"], TUE: ["8:30", "17:00"], WED: ["8:30", "17:00"], THU: ["8:30", "17:00"], FRI: ["8:30", "12:30"]}'
end


### Users ###

# Automatic ("robot") user credenitals, representing a sales representity
User.find_or_create_by(surname: "Robot") do |user|
  user.first_name = "E-Mail"
  user.email_address = "robot@mercator.mydomain.com"
  user.photo =  open("#{Rails.root}/materials/images/little-robot.png")
  user.sales = true
end

# Job User credentials, needs to be administrator
User.find_or_create_by(surname: "Job User") do |user|
  user.first_name = "Mercator"
  user.email_address = "jobs@mercator.mydomain.com"
  user.administrator = true
end

# Dummy customer credentials (used for price derivation e.g. in category filters)
User.find_or_create_by(surname: "Dummy Customer") do |user|
  user.first_name = "Mercator"
  user.email_address = "dummy_customer@mercator.mydomain.com"
end

# Payment customer credentials (used for price derivation e.g. in category filters)
User.find_or_create_by(surname: "MPay24") do |user|
  user.first_name = "Mercator"
  user.email_address = "mpay24@mercator.mydomain.com"
end


### Categories ###

# Mercator system category
Category.find_or_create_by(usage: :mercator) do |category|
  category.name_de =  "== Mercator =="
  category.name_en = "== Mercator =="
  category.description_de = "Mercator - Servicekategorien"
  category.description_en = "Mercator - Service Categories"
  category.position = 9999
  category.state = "deprecated"
  category.filtermin = 1
  category.filtermax = 1
end

# Category automatically created products from ERP import Job
Category.find_or_create_by(usage: :auto) do |category|
  category.name_de = "importiert"
  category.name_en = "imported"
  category.description_de = "Automatisch angelegte Produkte aus ERP Batchimport"
  category.description_en = "automatically created products from ERP import Job"
  category.long_description_de = "Bitte Produkte vervollständigen und kategorisieren."
  category.long_description_en = "Please complete products and put them into categories"
  category.parent_id = Category.mercator.id
  category.state = "deprecated"
  category.position = 1
  category.filtermin = 1
  category.filtermax = 1
end

# Category for Novelties
Category.find_or_create_by(squeel_condition: "kennzeichen == 'N'") do |category|
  category.name_de = "Neuheiten"
  category.name_en = "New"
  category.description_de = "Neuheiten"
  category.description_en = "New"
  category.long_description_de = "Neuheiten"
  category.long_description_en = "Novelties"
  category.state = "active"
  category.position = 1
  category.filtermin = 1
  category.filtermax = 1
  category.usage = :squeel
end

# Category for Topseller
Category.find_or_create_by(squeel_condition: "kennzeichen == 'T'") do |category|
  category.name_de = "Topseller"
  category.name_en = "Topseller"
  category.description_de = "Topseller"
  category.description_en = "Topseller"
  category.long_description_de = "Topseller"
  category.long_description_en = "Topseller"
  category.state = "active"
  category.position = 1
  category.filtermin = 1
  category.filtermax = 1
  category.usage = :squeel
end

# Category for Orphans
Category.find_by(usage: :orphans) do |category|
  category.name_de = "verwaist"
  category.name_en = "Orphans"
  category.description_de = "verwaiste Artikel"
  category.description_en = "Orphans"
  category.long_description_de = "verwaiste Artikel"
  category.long_description_en = "Orphans"
  category.parent_id = Category.mercator
  category.state = "deprecated"
  category.position = 2
  category.filtermin = 1
  category.filtermax = 1
end


### GTC ###

Gtc.find_by(title_de: "AGB") do |gtc|
  gtc.title_en = "GTC"
  gtc.content_de = "FIXME! Geben Sie hier Ihre Allgemeinen Geschäftsbedingungen ein!"
  gtc.content_en = "<p>FIXME! Enter your GTCs here!"
  gtc.version_of = "2015-01-01"
  gtc.markup = "HTML"
end