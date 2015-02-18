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

ShippingCost.find_or_create_by(shipping_method: "parcel_service_shipment") do |shipping_cost|
  shipping_cost.value = 12
  shipping_cost.country_id = 104
  shipping_cost.vat = 20
end