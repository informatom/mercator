### Constants ###

# Site name
Constant.create(key: :site_name, value: "My Mercator")

# delivery times, in german, comma seperated
Constant.create(key: :delivery_times_de, value: "1-2 Tage,2-4 Tage,1 Woche,auf Anfrage")

# delivery times, comma seperated
Constant.create(key: :delivery_times_en, value: "1-2 days,2-4 days,1 week,on request")

# Domain used for web shop and consulting part of mercator, CMS and Podcasting area, respectively
Constant.create(key: :shop_domain, value: "shop.mydomain")
Constant.create(key: :cms_domain, value: "cms.mydomain")
Constant.create(key: "podcast_domain", value: "podcast.mydomain")

# store strategy / policy: "true" of "false"
Constant.create(key: :fifo, value: "true")

# article name for shipping_casts
Constant.create(key: :shipping_cost_article, value: "SHIPPING_COSTS")

# E-mail address for service ("office") mails
Constant.create(key: :service_mail, value: "no-reply@my-mercator.mydomain")

# Office hours, hash of array values, be careful with the quotes!
# Example: '{MON: ["11:30", "17:00"], TUE: ["8:30", "17:00"], WED: ["8:30", "17:00"], THU: ["8:30", "17:00"], FRI: ["8:30", "12:30"]}'
Constant.create(key: :office_hours,
                value: '{MON: ["11:30", "17:00"], TUE: ["8:30", "17:00"], WED: ["8:30", "17:00"], THU: ["8:30", "17:00"], FRI: ["8:30", "12:30"]}')

# Coutry code for automatic holiday derivation, e.g. "de", "at"
Constant.create(key: "holiday_country_code", value: "at")

# Should be set to "true", if an ERP system is responsible for pricing
Constant.create(key: "prices_are_set_by_erp_and_therefore_not_editable", value: "false")

# Credentials for MPay24 user, only necessary, if E-Payment is installed and enabled
Constant.create(key: "mpay_test_username", value: "FIXME!")
Constant.create(key: "mpay_test_password", value: "FIXME!")
Constant.create(key: "mpay_production_username", value: "FIXME!")
Constant.create(key: "mpay_production_password", value: "FIXME!")

# Email subject for order confirmation email message
Constant.create(key: "order_corfirmation_mail_subject", value: "Bestellinfo")

# Email subject for notification email on new orders in state 'in payment'
Constant.create(key: "order_notify_in_payment_mail_subject",
                value: "neue Bestellungen im Status Bezahlung")

# Credentials for twitter user, only necessary, when twitter timeline should be displayed
Constant.create(key: "twitter_user", value: "FIXME!")
Constant.create(key: "twitter_consumer_key", value: "FIXME!")
Constant.create(key: "twitter_consumer_secret", value: "FIXME!")
Constant.create(key: "twitter_oauth_token", value: "FIXME!")
Constant.create(key: "twitter_uoauth_token_secret", value: "FIXME!")


### Users ###

# Your admin User
User.create(surname: "FIXME!",
            first_name: "FIXME!",
            email_address: "FIXME!",
            administrator: true,
            password: "FIXME!",
            password_confirmation: "FIXME!")

# Automatic ("robot") user credenitals, representing a sales representity
User.create(surname: "Robot",
            first_name: "E-Mail",
            email_address: "robot@mercator.mydomain.com",
            photo: open("#{Rails.root}/materials/images/little-robot.png"),
            sales: true)

# Job User credentials, needs to be administrator
User.create(surname: "Job User",
            first_name: "Mercator",
            email_address: "jobs@mercator.mydomain.com",
            administrator: true)

# Dummy customer credentials (used for price derivation e.g. in category filters)
User.create(surname: "Dummy Customer",
            first_name: "Mercator",
            email_address: "dummy_customer@mercator.mydomain.com")

# Payment customer credentials (used for price derivation e.g. in category filters)
User.create(surname: "MPay24",
            first_name: "Mercator",
            email_address: "mpay24@mercator.mydomain.com")


### Categories ###

# These categories are fine for a quick, no customization necessary.
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
Category.find_or_create_by(usage: :orphans) do |category|
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

# These templates are fine for a quick start, no customization necessary.
Gtc.find_or_create_by(title_de: "AGB") do |gtc|
  gtc.title_en = "GTC"
  gtc.content_de = "FIXME! Geben Sie hier Ihre Allgemeinen Geschäftsbedingungen ein!"
  gtc.content_en = "<p>FIXME! Enter your GTCs here!"
  gtc.version_of = "2015-01-01"
  gtc.markup = "HTML"
end

### Page Templates ###

PageTemplate.find_or_create_by(name: "simple") do |page_template|
  page_template.content = "<page title=\"Home\">\r\n\r\n  <body: class=\"front-page\"/>\r\n\r\n  " +
                          "<content:>\r\n    <section class=\"content-body\">\r\n      <div class" +
                          "=\"row text-center\">\r\n        <div class=\"col-lg-12\">\r\n        " +
                          "  <container name='main-content'/>\r\n        </div>\r\n      </div>\r" +
                          "\n    </section>\r\n  </content:>\r\n  \r\n  <footer: class=\"text-cen" +
                          "ter\">\r\n    <container name='footer'/>\r\n  </footer:>\r\n</page>"
  page_template.dryml = true
end

PageTemplate.find_or_create_by(name: "AGB") do |page_template|
  page_template.content = "<page title=\"Home\">\r\n\r\n  <body: class=\"front-page\"/>\r\n    \r" +
                          "\n  <content:>\r\n    <section class=\"content-body\">\r\n      <div c" +
                          "lass=\"row\">\r\n        <div class=\"col-lg-12\">\r\n          <h1>\r" +
                          "\n            <%= raw Gtc.order(version_of: :desc).first.title %>\r\n " +
                          "         </h1>\r\n          <%= raw Gtc.order(version_of: :desc).first" +
                          ".content %>\r\n        </div>\r\n      </div>\r\n    </section>\r\n  <" +
                          "/content:>\r\n  \r\n  <footer: class=\"text-center\">\r\n    <containe" +
                          "r name='footer'/>\r\n  </footer:>\r\n</page>"
  page_template.dryml = true
end

PageTemplate.find_or_create_by(name: "demo") do |page_template|
  page_template.content = "<!-- Dieses Template dient zur Erklärung, wie Templates möglichst einf" +
                          "ach erstellt werden können.-->\r\n\r\n<!-- Kommentare: \r\n     Templa" +
                          "tes können Kommentare enthalten, dies und der Kommentar darüber ist ei" +
                          "n Beispiel für die Syntax. \r\n     Kommentare können auch mehrzeilig " +
                          "sein.\r\n\r\n     Zweck von Templates:\r\n     Um die Struktur gleich " +
                          "aufgebauter Webseiten nicht auf jeder Webseite neu definieren zu müsse" +
                          "n, gibt es Templates. \r\n     Für jede Webseite der Website ist ein T" +
                          "emplate zuzuweisen. \r\n     Templates können in beliebig vielen Webse" +
                          "iten verwendet werden. \r\n\r\n     Platzhalter: \r\n     Um an gewiss" +
                          "en Stellen des Templates Inhalt webseitenspezifisch zuzuweisen, werden" +
                          " Platzhalter verwendet.\r\n     Diese Platzhalter sind in der Liste de" +
                          "r Platzhalter in der Templatepflege durch Beistriche getrennt anzugebe" +
                          "n.\r\n     In diesen Template verwenden wir die Platzhalter beispielbi" +
                          "ld, beispieltext1 und beispieltext2.\r\n     Konkret weisen wir in der" +
                          " Webseitenpflege jedem Platzhalter genau einen Baustein zu.\r\n\r\n   " +
                          "  DRYML: \r\n     Templates können in ERB oder in DRYML erfasst werden" +
                          ". \r\n     Da die Erstellung in DRYML einfacher ist, werden wir sie hi" +
                          "er vorziehen.\r\n     Um ein DRYML Template zu erstellen klickt man di" +
                          "e Checkboy DRYML oben an.\r\n\r\n     DRYML ist im Prinzip HTML, mit 2" +
                          " Unterschieden.\r\n     1 Tags, die keinen Inhalt haben, müssen geschl" +
                          "ossen werden.\r\n       zum Beispiel ist nur der Tag <br/> gültig, nic" +
                          "ht aber <br>\r\n     2 Es gibt neue Tags, die in Mercator definiert wu" +
                          "rden, um die Einbindung von Inhalten zu vereinfachen.   \r\n\r\n     B" +
                          "ootstrap 3:\r\n     Unsere Templateengine versteht alle Komponenten de" +
                          "s Twitter Bootstrap Frameworks in der Version 3: \r\n     http://getbo" +
                          "otstrap.com/\r\n     Damit können viele unterschiedliche Komponenten m" +
                          "it geringem Aufwand eingabaut werden.\r\n\r\n     Der Inhalt eine Seit" +
                          "e wird im content:-Tag des page-Tags definiert \r\n     (Der Doppelpun" +
                          "kt hinter content ist wesentlich.) -->\r\n\r\n<page title=\'Home\'>\r" +
                          "\n  <content:>\r\n\r\n    <!-- Das Grid:\r\n         Inhalt wird zunäc" +
                          "hst zeilen- und dann innerhalb spaltenweise definiert.\r\n         Beg" +
                          "innen wir mit dem einfachen Fall: Eine Zeile mit einer Spalte mit eine" +
                          "m Beispieltext. -->\r\n\r\n    <!-- Wir eröffnen eine Zeile: -->\r\n  " +
                          "    <div class=\"row\">\r\n        \r\n        <!-- Eine Zeile ist 12 " +
                          "Einheiten breit, unser Element soll über die gesamte Breite gehen -->" +
                          "\r\n        <div class=\"col-lg-12\">\r\n          \r\n          <!-- " +
                          "Um textlichen Inhalt einzubetten, verwenden wir den Container-Tag, \r" +
                          "\n               im Attribut name geben wir den Namen des Platzhalters" +
                          " an -->\r\n          <container name='beispieltext1'/>\r\n        </di" +
                          "v>\r\n      </div>\r\n    \r\n    \r\n    <!-- Als nächstes Beispiel s" +
                          "tellen wir zwei unterschiedlich breite Spalten dar, \r\n         im li" +
                          "nken Drittel den beispieltext2, im Rest wieder den beispieltext1 -->\r" +
                          "\n    <div class=\"row\">\r\n      <div class=\"col-lg-4\">\r\n       " +
                          " <container name='beispieltext2'/>\r\n      </div>\r\n      <div class" +
                          "=\"col-lg-8\">\r\n        <container name='beispieltext1'/>\r\n      <" +
                          "/div>\r\n    </div>\r\n    \r\n    <!-- Zum Abschluss drei Spalten mit" +
                          " einem Beispielbild in der Mitte\r\n         der Tag heisst photo, der" +
                          " name des Platzhalters ist wieder im name Attribut anzugeben. -->\r\n " +
                          "   <div class=\"row\">\r\n      <div class=\"col-lg-4\">\r\n        <c" +
                          "ontainer name='beispieltext2'/>\r\n      </div>\r\n      <div class=\"" +
                          "col-lg-4\">\r\n        <photo name='beispielbild' width=\"100%\"/>\r\n" +
                          "        <!-- Wir geben 100% als Breite an, damit das Bild die gesamte " +
                          "Spalte ausfüllt. \r\n             Würden wir die Breite nicht angeben," +
                          " würde es in Originialgröße dargestellt,\r\n             damit könnte " +
                          "es kleiner als die Spaltenbreite sein, aber auch über die Spalte hinau" +
                          "sstehen. -->\r\n      </div>\r\n      <div class=\"col-lg-4\">\r\n    " +
                          "    <container name='beispieltext1' />\r\n      </div>\r\n    </div>\r" +
                          "\n  <!-- Wir müssen noch die geöffneten Tags content: und page schlies" +
                          "sen. -->    \r\n  </content:>\r\n \r\n  <!-- Analog zum Tag für Photos" +
                          " gibt es auch einen für Dokumente, seine Syntax ist <document name=\'p" +
                          "latzhaltername\'/>  .\r\n       Die Tags <photo /> und <document /> dü" +
                          "rfen auch innerhalb der Platzhaltertexte verwendetet werden.\r\n      " +
                          " Damit können in einem Platzhalter beliebig viele Bilder und Dokumente" +
                          " dargestellt werden. -->    \r\n</page>\r\n\r\n"
  page_template.dryml = true
end


### ShippingCost ###

# Shipping cost value and tax
ShippingCost.find_or_create_by(shipping_method: "parcel_service_shipment") do |shipping_cost|
  shipping_cost.value = 12
  shipping_cost.country_id = 104
  shipping_cost.vat = 20
end


### Country ###

# List of countries where service is web shop service is provided
# Restrict, if necessary!
Country.create(name_de: "Afghanistan", code: "AF", name_en: "Afghanistan")
Country.create(name_de: "Alandinseln", code: "AX", name_en: "Åland")
Country.create(name_de: "Albanien", code: "AL", name_en: "Albania")
Country.create(name_de: "Algerien", code: "DZ", name_en: "Algeria")
Country.create(name_de: "Amerikanisch-Ozeanien", code: "UM",
               name_en: "United States Minor Outlying Islands")
Country.create(name_de: "Amerikanisch-Samoa", code: "AS", name_en: "American Samoa")
Country.create(name_de: "Amerikanische Jungferninseln", code: "VI", name_en: "Virgin Islands, U.S.")
Country.create(name_de: "Andorra", code: "AD", name_en: "Andorra")
Country.create(name_de: "Angola", code: "AO", name_en: "Angola")
Country.create(name_de: "Anguilla", code: "AI", name_en: "Anguilla")
Country.create(name_de: "Antarktis", code: "AQ", name_en: "Antarctica")
Country.create(name_de: "Antigua und Barbuda", code: "AG", name_en: "Antigua and Barbuda")
Country.create(name_de: "Argentinien", code: "AR", name_en: "Argentina")
Country.create(name_de: "Armenien", code: "AM", name_en: "Armenia")
Country.create(name_de: "Aruba", code: "AW", name_en: "Aruba")
Country.create(name_de: "Aserbaidschan", code: "AZ", name_en: "Azerbaijan")
Country.create(name_de: "Australien", code: "AU", name_en: "Australia")
Country.create(name_de: "Bahamas", code: "BS", name_en: "Bahamas")
Country.create(name_de: "Bahrain", code: "BH", name_en: "Bahrain")
Country.create(name_de: "Bangladesch", code: "BD", name_en: "Bangladesh")
Country.create(name_de: "Barbados", code: "BB", name_en: "Barbados")
Country.create(name_de: "Belarus", code: "BY", name_en: "Belarus")
Country.create(name_de: "Belgien", code: "BE", name_en: "Belgium")
Country.create(name_de: "Belize", code: "BZ", name_en: "Belize")
Country.create(name_de: "Benin", code: "BJ", name_en: "Benin")
Country.create(name_de: "Bermuda", code: "BM", name_en: "Bermuda")
Country.create(name_de: "Bhutan", code: "BT", name_en: "Bhutan")
Country.create(name_de: "Bolivien", code: "BO", name_en: "Bolivia")
Country.create(name_de: "Bosnien und Herzegowina", code: "BA", name_en: "Bosnia and Herzegovina")
Country.create(name_de: "Botsuana", code: "BW", name_en: "Botswana")
Country.create(name_de: "Bouvetinsel", code: "BV", name_en: "Bouvet Island")
Country.create(name_de: "Brasilien", code: "BR", name_en: "Brazil")
Country.create(name_de: "Britische Jungferninseln", code: "VG", name_en: "Virgin Islands, British")
Country.create(name_de: "Britisches Territorium im Indischen Ozean", code: "IO",
               name_en: "British Indian Ocean Territory")
Country.create(name_de: "Brunei Darussalam", code: "BN", name_en: "Brunei Darussalam")
Country.create(name_de: "Bulgarien", code: "BG", name_en: "Bulgaria")
Country.create(name_de: "Burkina Faso", code: "BF", name_en: "Burkina Faso")
Country.create(name_de: "Burundi", code: "BI", name_en: "Burundi")
Country.create(name_de: "Chile", code: "CL", name_en: "Chile")
Country.create(name_de: "China", code: "CN", name_en: "China")
Country.create(name_de: "Cookinseln", code: "CK", name_en: "Cook Islands")
Country.create(name_de: "Costa Rica", code: "CR", name_en: "Costa Rica")
Country.create(name_de: "Côte d’Ivoire", code: "CI", name_en: "Côte d'Ivoire")
Country.create(name_de: "Demokratische Republik Kongo", code: "CD", name_en: "Congo (Kinshasa)")
Country.create(name_de: "Demokratische Volksrepublik Korea", code: "KP", name_en: "Korea, North")
Country.create(name_de: "Deutschland", code: "DE", name_en: "Germany")
Country.create(name_de: "Dominica", code: "DM", name_en: "Dominica")
Country.create(name_de: "Dominikanische Republik", code: "DO", name_en: "Dominican Republic")
Country.create(name_de: "Dschibuti", code: "DJ", name_en: "Djibouti")
Country.create(name_de: "Dänemark", code: "DK", name_en: "Denmark")
Country.create(name_de: "Ecuador", code: "EC", name_en: "Ecuador")
Country.create(name_de: "El Salvador", code: "SV", name_en: "El Salvador")
Country.create(name_de: "Eritrea", code: "ER", name_en: "Eritrea")
Country.create(name_de: "Estland", code: "EE", name_en: "Estonia")
Country.create(name_de: "Falklandinseln", code: "FK", name_en: "Falkland Islands")
Country.create(name_de: "Fidschi", code: "FJ", name_en: "Fiji")
Country.create(name_de: "Finnland", code: "FI", name_en: "Finland")
Country.create(name_de: "Frankreich", code: "FR", name_en: "France")
Country.create(name_de: "Französisch-Guayana", code: "GF", name_en: "French Guiana")
Country.create(name_de: "Französisch-Polynesien", code: "PF", name_en: "French Polynesia")
Country.create(name_de: "Französische Süd- und Antarktisgebiete", code: "TF",
               name_en: "French Southern Lands")
Country.create(name_de: "Färöer", code: "FO", name_en: "Faroe Islands")
Country.create(name_de: "Gabun", code: "GA", name_en: "Gabon")
Country.create(name_de: "Gambia", code: "GM", name_en: "Gambia")
Country.create(name_de: "Georgien", code: "GE", name_en: "Georgia")
Country.create(name_de: "Ghana", code: "GH", name_en: "Ghana")
Country.create(name_de: "Gibraltar", code: "GI", name_en: "Gibraltar")
Country.create(name_de: "Grenada", code: "GD", name_en: "Grenada")
Country.create(name_de: "Griechenland", code: "GR", name_en: "Greece")
Country.create(name_de: "Grönland", code: "GL", name_en: "Greenland")
Country.create(name_de: "Guadeloupe", code: "GP", name_en: "Guadeloupe")
Country.create(name_de: "Guam", code: "GU", name_en: "Guam")
Country.create(name_de: "Guatemala", code: "GT", name_en: "Guatemala")
Country.create(name_de: "Guernsey", code: "GG", name_en: "Guernsey")
Country.create(name_de: "Guinea", code: "GN", name_en: "Guinea")
Country.create(name_de: "Guinea-Bissau", code: "GW", name_en: "Guinea-Bissau")
Country.create(name_de: "Guyana", code: "GY", name_en: "Guyana")
Country.create(name_de: "Haiti", code: "HT", name_en: "Haiti")
Country.create(name_de: "Heard- und McDonald-Inseln", code: "HM",
               name_en: "Heard and McDonald Islands")
Country.create(name_de: "Honduras", code: "HN", name_en: "Honduras")
Country.create(name_de: "Indien", code: "IN", name_en: "India")
Country.create(name_de: "Indonesien", code: "ID", name_en: "Indonesia")
Country.create(name_de: "Irak", code: "IQ", name_en: "Iraq")
Country.create(name_de: "Iran", code: "IR", name_en: "Iran")
Country.create(name_de: "Irland", code: "IE", name_en: "Ireland")
Country.create(name_de: "Island", code: "IS", name_en: "Iceland")
Country.create(name_de: "Isle of Man", code: "IM", name_en: "Isle of Man")
Country.create(name_de: "Israel", code: "IL", name_en: "Israel")
Country.create(name_de: "Italien", code: "IT", name_en: "Italy")
Country.create(name_de: "Jamaika", code: "JM", name_en: "Jamaica")
Country.create(name_de: "Japan", code: "JP", name_en: "Japan")
Country.create(name_de: "Jemen", code: "YE", name_en: "Yemen")
Country.create(name_de: "Jersey", code: "JE", name_en: "Jersey")
Country.create(name_de: "Jordanien", code: "JO", name_en: "Jordan")
Country.create(name_de: "Kaimaninseln", code: "KY", name_en: "Cayman Islands")
Country.create(name_de: "Kambodscha", code: "KH", name_en: "Cambodia")
Country.create(name_de: "Kamerun", code: "CM", name_en: "Cameroon")
Country.create(name_de: "Kanada", code: "CA", name_en: "Canada")
Country.create(name_de: "Kap Verde", code: "CV", name_en: "Cape Verde")
Country.create(name_de: "Kasachstan", code: "KZ", name_en: "Kazakhstan")
Country.create(name_de: "Katar", code: "QA", name_en: "Qatar")
Country.create(name_de: "Kenia", code: "KE", name_en: "Kenya")
Country.create(name_de: "Kirgisistan", code: "KG", name_en: "Kyrgyzstan")
Country.create(name_de: "Kiribati", code: "KI", name_en: "Kiribati")
Country.create(name_de: "Kokosinseln", code: "CC", name_en: "Cocos (Keeling) Islands")
Country.create(name_de: "Kolumbien", code: "CO", name_en: "Colombia")
Country.create(name_de: "Komoren", code: "KM", name_en: "Comoros")
Country.create(name_de: "Kongo", code: "CG", name_en: "Congo (Brazzaville)")
Country.create(name_de: "Kroatien", code: "HR", name_en: "Croatia")
Country.create(name_de: "Kuba", code: "CU", name_en: "Cuba")
Country.create(name_de: "Kuwait", code: "KW", name_en: "Kuwait")
Country.create(name_de: "Laos", code: "LA", name_en: "Laos")
Country.create(name_de: "Lesotho", code: "LS", name_en: "Lesotho")
Country.create(name_de: "Lettland", code: "LV", name_en: "Latvia")
Country.create(name_de: "Libanon", code: "LB", name_en: "Lebanon")
Country.create(name_de: "Liberia", code: "LR", name_en: "Liberia")
Country.create(name_de: "Libyen", code: "LY", name_en: "Libya")
Country.create(name_de: "Liechtenstein", code: "LI", name_en: "Liechtenstein")
Country.create(name_de: "Litauen", code: "LT", name_en: "Lithuania")
Country.create(name_de: "Luxemburg", code: "LU", name_en: "Luxembourg")
Country.create(name_de: "Madagaskar", code: "MG", name_en: "Madagascar")
Country.create(name_de: "Malawi", code: "MW", name_en: "Malawi")
Country.create(name_de: "Malaysia", code: "MY", name_en: "Malaysia")
Country.create(name_de: "Malediven", code: "MV", name_en: "Maldives")
Country.create(name_de: "Mali", code: "ML", name_en: "Mali")
Country.create(name_de: "Malta", code: "MT", name_en: "Malta")
Country.create(name_de: "Marokko", code: "MA", name_en: "Morocco")
Country.create(name_de: "Marshallinseln", code: "MH", name_en: "Marshall Islands")
Country.create(name_de: "Martinique", code: "MQ", name_en: "Martinique")
Country.create(name_de: "Mauretanien", code: "MR", name_en: "Mauritania")
Country.create(name_de: "Mauritius", code: "MU", name_en: "Mauritius")
Country.create(name_de: "Mayotte", code: "YT", name_en: "Mayotte")
Country.create(name_de: "Mazedonien", code: "MK", name_en: "Macedonia")
Country.create(name_de: "Mexiko", code: "MX", name_en: "Mexico")
Country.create(name_de: "Mikronesien", code: "FM", name_en: "Micronesia")
Country.create(name_de: "Monaco", code: "MC", name_en: "Monaco")
Country.create(name_de: "Mongolei", code: "MN", name_en: "Mongolia")
Country.create(name_de: "Montenegro", code: "ME", name_en: "Montenegro")
Country.create(name_de: "Montserrat", code: "MS", name_en: "Montserrat")
Country.create(name_de: "Mosambik", code: "MZ", name_en: "Mozambique")
Country.create(name_de: "Myanmar", code: "MM", name_en: "Myanmar")
Country.create(name_de: "Namibia", code: "NA", name_en: "Namibia")
Country.create(name_de: "Nauru", code: "NR", name_en: "Nauru")
Country.create(name_de: "Nepal", code: "NP", name_en: "Nepal")
Country.create(name_de: "Neukaledonien", code: "NC", name_en: "New Caledonia")
Country.create(name_de: "Neuseeland", code: "NZ", name_en: "New Zealand")
Country.create(name_de: "Nicaragua", code: "NI", name_en: "Nicaragua")
Country.create(name_de: "Niederlande", code: "NL", name_en: "Netherlands")
Country.create(name_de: "Niederländische Antillen", code: "AN", name_en: "Netherlands Antilles")
Country.create(name_de: "Niger", code: "NE", name_en: "Niger")
Country.create(name_de: "Nigeria", code: "NG", name_en: "Nigeria")
Country.create(name_de: "Niue", code: "NU", name_en: "Niue")
Country.create(name_de: "Norfolkinsel", code: "NF", name_en: "Norfolk Island")
Country.create(name_de: "Norwegen", code: "NO", name_en: "Norway")
Country.create(name_de: "Nördliche Marianen", code: "MP", name_en: "Northern Mariana Islands")
Country.create(name_de: "Oman", code: "OM", name_en: "Oman")
Country.create(name_de: "Osttimor", code: "TL", name_en: "Timor-Leste")
Country.create(name_de: "Pakistan", code: "PK", name_en: "Pakistan")
Country.create(name_de: "Palau", code: "PW", name_en: "Palau")
Country.create(name_de: "Palästinensische Gebiete", code: "PS", name_en: "Palestine")
Country.create(name_de: "Panama", code: "PA", name_en: "Panama")
Country.create(name_de: "Papua-Neuguinea", code: "PG", name_en: "Papua New Guinea")
Country.create(name_de: "Paraguay", code: "PY", name_en: "Paraguay")
Country.create(name_de: "Peru", code: "PE", name_en: "Peru")
Country.create(name_de: "Philippinen", code: "PH", name_en: "Philippines")
Country.create(name_de: "Pitcairn", code: "PN", name_en: "Pitcairn")
Country.create(name_de: "Polen", code: "PL", name_en: "Poland")
Country.create(name_de: "Portugal", code: "PT", name_en: "Portugal")
Country.create(name_de: "Puerto Rico", code: "PR", name_en: "Puerto Rico")
Country.create(name_de: "Republik Korea", code: "KR", name_en: "Korea, South")
Country.create(name_de: "Republik Moldau", code: "MD", name_en: "Moldova")
Country.create(name_de: "Réunion", code: "RE", name_en: "Reunion")
Country.create(name_de: "Ruanda", code: "RW", name_en: "Rwanda")
Country.create(name_de: "Rumänien", code: "RO", name_en: "Romania")
Country.create(name_de: "Russische Föderation", code: "RU", name_en: "Russian Federation")
Country.create(name_de: "Salomonen", code: "SB", name_en: "Solomon Islands")
Country.create(name_de: "Sambia", code: "ZM", name_en: "Zambia")
Country.create(name_de: "Samoa", code: "WS", name_en: "Samoa")
Country.create(name_de: "San Marino", code: "SM", name_en: "San Marino")
Country.create(name_de: "São Tomé und Príncipe", code: "ST", name_en: "Sao Tome and Principe")
Country.create(name_de: "Saudi-Arabien", code: "SA", name_en: "Saudi Arabia")
Country.create(name_de: "Schweden", code: "SE", name_en: "Sweden")
Country.create(name_de: "Schweiz", code: "CH", name_en: "Switzerland")
Country.create(name_de: "Senegal", code: "SN", name_en: "Senegal")
Country.create(name_de: "Serbien", code: "RS", name_en: "Serbia")
Country.create(name_de: "Serbien und Montenegro", code: "CS", name_en: "Serbia and Montenegro")
Country.create(name_de: "Seychellen", code: "SC", name_en: "Seychelles")
Country.create(name_de: "Sierra Leone", code: "SL", name_en: "Sierra Leone")
Country.create(name_de: "Simbabwe", code: "ZW", name_en: "Zimbabwe")
Country.create(name_de: "Singapur", code: "SG", name_en: "Singapore")
Country.create(name_de: "Slowakei", code: "SK", name_en: "Slovakia")
Country.create(name_de: "Slowenien", code: "SI", name_en: "Slovenia")
Country.create(name_de: "Somalia", code: "SO", name_en: "Somalia")
Country.create(name_de: "Sonderverwaltungszone Hongkong", code: "HK", name_en: "Hong Kong")
Country.create(name_de: "Sonderverwaltungszone Macao", code: "MO", name_en: "Macau")
Country.create(name_de: "Spanien", code: "ES", name_en: "Spain")
Country.create(name_de: "Sri Lanka", code: "LK", name_en: "Sri Lanka")
Country.create(name_de: "St. Barthélemy", code: "BL", name_en: "Saint Barthélemy")
Country.create(name_de: "St. Helena", code: "SH", name_en: "Saint Helena")
Country.create(name_de: "St. Kitts und Nevis", code: "KN", name_en: "Saint Kitts and Nevis")
Country.create(name_de: "St. Lucia", code: "LC", name_en: "Saint Lucia")
Country.create(name_de: "St. Martin", code: "MF", name_en: "Saint Martin (French part)")
Country.create(name_de: "St. Pierre und Miquelon", code: "PM", name_en: "Saint Pierre and Miquelon")
Country.create(name_de: "St. Vincent und die Grenadinen", code: "VC",
               name_en: "Saint Vincent and the Grenadines")
Country.create(name_de: "Sudan", code: "SD", name_en: "Sudan")
Country.create(name_de: "Suriname", code: "SR", name_en: "Suriname")
Country.create(name_de: "Svalbard und Jan Mayen", code: "SJ", name_en: "Svalbard and Jan Mayen Islands")
Country.create(name_de: "Swasiland", code: "SZ", name_en: "Swaziland")
Country.create(name_de: "Südafrika", code: "ZA", name_en: "South Africa")
Country.create(name_de: "Südgeorgien und die Südlichen Sandwichinseln", code: "GS",
               name_en: "South Georgia and South Sandwich Islands")
Country.create(name_de: "Syrien", code: "SY", name_en: "Syria")
Country.create(name_de: "Tadschikistan", code: "TJ", name_en: "Tajikistan")
Country.create(name_de: "Taiwan", code: "TW", name_en: "Taiwan")
Country.create(name_de: "Tansania", code: "TZ", name_en: "Tanzania")
Country.create(name_de: "Thailand", code: "TH", name_en: "Thailand")
Country.create(name_de: "Togo", code: "TG", name_en: "Togo")
Country.create(name_de: "Tokelau", code: "TK", name_en: "Tokelau")
Country.create(name_de: "Tonga", code: "TO", name_en: "Tonga")
Country.create(name_de: "Trinidad und Tobago", code: "TT", name_en: "Trinidad and Tobago")
Country.create(name_de: "Tschad", code: "TD", name_en: "Chad")
Country.create(name_de: "Tschechische Republik", code: "CZ", name_en: "Czech Republic")
Country.create(name_de: "Tunesien", code: "TN", name_en: "Tunisia")
Country.create(name_de: "Turkmenistan", code: "TM", name_en: "Turkmenistan")
Country.create(name_de: "Turks- und Caicosinseln", code: "TC", name_en: "Turks and Caicos Islands")
Country.create(name_de: "Tuvalu", code: "TV", name_en: "Tuvalu")
Country.create(name_de: "Türkei", code: "TR", name_en: "Turkey")
Country.create(name_de: "Uganda", code: "UG", name_en: "Uganda")
Country.create(name_de: "Ukraine", code: "UA", name_en: "Ukraine")
Country.create(name_de: "Ungarn", code: "HU", name_en: "Hungary")
Country.create(name_de: "Uruguay", code: "UY", name_en: "Uruguay")
Country.create(name_de: "Usbekistan", code: "UZ", name_en: "Uzbekistan")
Country.create(name_de: "Vanuatu", code: "VU", name_en: "Vanuatu")
Country.create(name_de: "Vatikanstadt", code: "VA", name_en: "Vatican City")
Country.create(name_de: "Venezuela", code: "VE", name_en: "Venezuela")
Country.create(name_de: "Vereinigte Arabische Emirate", code: "AE", name_en: "United Arab Emirates")
Country.create(name_de: "Vereinigte Staaten", code: "US", name_en: "United States of America")
Country.create(name_de: "Vereinigtes Königreich", code: "GB", name_en: "United Kingdom")
Country.create(name_de: "Vietnam", code: "VN", name_en: "Vietnam")
Country.create(name_de: "Wallis und Futuna", code: "WF", name_en: "Wallis and Futuna Islands")
Country.create(name_de: "Weihnachtsinsel", code: "CX", name_en: "Christmas Island")
Country.create(name_de: "Westsahara", code: "EH", name_en: "Western Sahara")
Country.create(name_de: "Zentralafrikanische Republik", code: "CF",
               name_en: "Central African Republic")
Country.create(name_de: "Zypern", code: "CY", name_en: "Cyprus")
Country.create(name_de: "Ägypten", code: "EG", name_en: "Egypt")
Country.create(name_de: "Äquatorialguinea", code: "GQ", name_en: "Equatorial Guinea")
Country.create(name_de: "Äthiopien", code: "ET", name_en: "Ethiopia")
Country.create(name_de: "Österreich", code: "AT", name_en: "Austria")
