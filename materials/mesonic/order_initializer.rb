require 'enumerator'

class Mesonic::OrderInitializer

  attr_accessor :mesonic_order
  attr_accessor :mesonic_order_items
  attr_accessor :opensteam_order
  attr_accessor :opensteam_cart
  attr_accessor :opensteam_cart_items
  attr_accessor :customer
  attr_accessor :timestamp

  def initialize( opensteam_order, cart, customer, order_number = nil, stamp = Time.now )
    @opensteam_order = opensteam_order
    @opensteam_cart  = cart
    @customer = customer
    @custom_order_number = order_number
    @timestamp = stamp
    @mesonic_order = IvellioVellin::Order.new
    @mesonic_order_items = []
    @mesocomp = Mesonic::AktMandant.mesocomp
    @mesoyear = Mesonic::AktMandant.mesoyear
  end

  def valid?
    ( [ mesonic_order_valid? ] + [ mesonic_order_items_valid? ] ).all?
  end

  def save
    success = []
    IvellioVellin::Order.transaction do
      success << @mesonic_order.save
      success += @mesonic_order_items.collect(&:save)
    end
    success
  end

  def mesonic_order_valid?
    @mesonic_order.valid?
  end

  def mesonic_order_items_valid?
    @mesonic_order_items.collect(&:valid?).all?
  end

  def set_mesonic_order_customer_information!
    @mesonic_order.c020 = @customer.mesonic_account_id.nil? ? @customer.id : @customer.mesonic_account_id
    @mesonic_order.c021 = @customer.mesonic_kontenstamm.try(:kunde?) ? @customer.mesonic_kontenstamm.kontonummer : "09WEB"
  end

  def set_mesonic_order_price_information!
    @opensteam_cart.cart_items.reload

    if @opensteam_order.delivery?
      cart_total_price = @opensteam_cart.cart_items.with_shipping_rate_for( @customer ).total_price
    else
      cart_total_price = @opensteam_cart.cart_items.total_price
    end

    @mesonic_order.c099 = cart_total_price
    @mesonic_order.c100 = cart_total_price
  end

  def set_mesonic_order_timestamp!
    if @custom_order_number
      @mesonic_order.c022 = @custom_order_number
    else
      @mesonic_order.c022 = "#{@timestamp.strftime('%y%m%d%H%M%S')}#{@timestamp.usec}" # laufnummer
    end
  end

  def set_mesonic_order_id!
    @mesonic_order.id = [ @mesonic_order.c021, @mesonic_order.c022 ].join("-") # primary key
  end

  def mesonic_kontenstamm
    @customer.mesonic_kontenstamm
  end

  def mesonic_kontenstamm_fakt
    @customer.mesonic_kontenstamm_fakt
  end

  def mesonic_order_spec
    lambda { |o|
      o.c023 = "N" # druckstatus angebot
      o.c024 = "N" # druckstatus auftragsbestätigung
      o.c025 = "N" # durckstatus lieferschein
      o.c026 = "N" # druckstatus faktura
      o.c027 = @timestamp # datum angebot
      o.c030 = @customer.account_number #### konto-lieferadresse, Wert "1/00007" immer gleich?
      o.c034 = mesonic_kontenstamm_fakt.belegart.c014 # #### belegart
      o.c035 = mesonic_kontenstamm_fakt.c077 # belegart
      o.c036 = mesonic_kontenstamm_fakt.c065 # vertreternummer
      o.c037 = 0 # nettotage (sql statement folgt ?? )
      o.c038 = 0 # skonto%1 (sql statement folgt ?? )
      o.c039 = 0 # skontotage1 (sql statement folgt ?? )
      o.c040 = 0 # summenrabatt (sql statement folgt ?? )
      o.c041 = 0 # fw-zeile (immer 0)
      o.c047 = mesonic_kontenstamm_fakt.c066  # preisliste
      o.c049 = 0 # fw einheit
      o.c050 = 0 # fw-faktor
#      o.c051 = mesonic_kontenstamm_fakt.c107  # kondition1
      o.c053 = mesonic_kontenstamm_fakt.c122 # kostentraeger
      o.c054 = 400 # kostenstelle
      o.c056 = 0 # skonto%2 ( sql statement folgt ?? )
      o.c057 = 0 # skontotage2 ( sql statement folgt ?? )
      o.c059 = @timestamp # datum d. erstanlage
      o.c074 = 0 # kennzeichen f FW-Umrechung
      o.c075 = 0 # flag für Webinterface
      o.c076 = 0 # Dokumenten ID
      o.c077 = 0 # FW-Notierungsflag
      o.c078 = 0 # xml-erweiterung
      o.c080 = 0 # filler
      o.c086 = 0 # teilliefersperre
      o.c088 = 0 # priorität
      # o.c089 = 1 # freier text 1 ## flag versandart ### written by form
      o.c090 = 0 # freier text 2
      o.c091 = 0 # freier text 3
      o.c092 = 0 # freier text 4
      o.c093 = 0 # flag sammelrechnung
      o.c094 = 0 # flag methode
      o.c095 = 0 # ausprägung 1
      o.c096 = 0 # ausprägung 2
      #      o.c097 = ## flag zahlungsart ### written by form
      o.c098 = 101 # flag freigabekontrolle angebot
      o.c099 = 0 # kumulierter zahlungsbetrag
      o.c100 = 0 # endbetrag
      o.c102 = 0 # rohertrag
      o.c103 = @timestamp + 3.days #
      o.c104 = 0 # ansprechpartner rechnungsadresse
      o.c105 = 0 # ansprechpartner lieferadresse
      o.c106 = 0 # fremdwährungskurs
      o.c109 = -1 # kontrakttyp
      o.c111 = 2 # exim durchgeführte änderungen
      o.c113 = o.c021 #  o.c113 = "09WEB" # konto rechnungsadresse
      o.c114 = 0 # anzahlungsbetrag
      o.c115 = 101 # flag freigabekontrolle auftrag
      o.c116 = 101 # flag freigabekontrolle lieferschein
      o.c117 = 101 # flag freigabekontrolle faktura
      o.c118 = 0 # euro rohertrag
      o.c120 = 0 # fw-einheit für storno
      o.c121 = 0 # sortierung
      o.c123 = 0 # textkennzeichen konto
      o.c126 = 0 # aktionsplanzeile
      o.c127 = 0 # karenztage
      o.c137 = 2
      o.c139 = 0
      o.c140 = 0
      o.c141 = 0
      o.c142 = 0
      o.c143 = 0
      o.C151 = 8
      o.C152 = "900001"
      o.C153 = 0
      o.C154 = 0
      o.C155 = 0
      o.C156 = 0
      o.C157 = 0
      o.C158 = 0
      o.C159 = 0
      o.C160 = 0
      o.mesocomp = @mesocomp
      o.mesoyear = @mesoyear
      o.mesoprim = "#{o.c000}-#{@mesocomp}-#{@mesoyear}"
    }
  end

  def initialize_mesonic_order!
    self.copy_opensteam_order_information!
    self.set_mesonic_order_customer_information!
    self.set_mesonic_order_timestamp!
    self.set_mesonic_order_id!
    mesonic_order_spec.call( @mesonic_order )
    self.set_mesonic_order_price_information!
  end

  def initialize_mesonic_order_items!
    order_kontonummer = @mesonic_order.c021
    order_primary_key = @mesonic_order.c000
    order_laufnummer  = @mesonic_order.c022

    @opensteam_cart.cart_items.reload

    if @opensteam_order.delivery?
      cart_items = @opensteam_cart.cart_items.with_shipping_rate_for( @customer )
    else
      cart_items = @opensteam_cart.cart_items
    end

    @mesonic_order_items = cart_items.enum_for( :each_with_index ).collect { |cart_item, index|

      returning( IvellioVellin::OrderItem.new ) do |order_item|
        order_item.id = [ order_primary_key, "%06d" % (index.to_i + 1 ) ].join("-")
        order_item.c003 = cart_item.inventory.article_number
        order_item.c004 = cart_item.inventory.Bezeichnung
        order_item.c005 = cart_item.menge # menge bestellt
        order_item.c006 = cart_item.menge # menge geliefert
        order_item.c007 = cart_item.einzelpreis # einzelpreis
        order_item.c008 = 0 # zeilenrabatt 1 und 2
        order_item.c009 = 4002 # erlöskonto
        order_item.c010 = cart_item.inventory.Steuersatzzeile # umsatzsteuer prozentsatz
        order_item.c011 = 1 # statistikkennzeichen
        order_item.c012 = cart_item.inventory.ArtGruppe # artikelgruppe
        order_item.c013 = 0 # liefertage
        order_item.c014 = cart_item.inventory.Provisionscode # provisionscode
        order_item.c015 = nil # colli
        order_item.c016 = 0 # menge bereits geliefert
        order_item.c018 = 0 # faktor 1 nach formeleingabe
        order_item.c019 = 0 # faktor 2 nach formeleingabe
        order_item.c020 = 0 # faktor 3 nach formeleingabe
        order_item.c021 = 0 # zeilenrabatt %1
        order_item.c022 = 0 # zeilenrabatt %2
        order_item.c023 = 0 # einstandspreis
        order_item.c024 = nil # umstatzsteuercode
        order_item.c025 = @mesonic_order.c027 # lieferdatum
        order_item.c026 = 400 # kostenstelle
        order_item.c027 = 0 # lieferwoche
        order_item.c031 = cart_item.gesamtwert # gesamtwert
        order_item.c032 = 0 # positionslevel
        order_item.c033 = nil # positionsnummer text
        order_item.c034 = cart_item.inventory.Gewicht # gewicht
        order_item.c035 = 0 # einstandspreis KZ
        order_item.c042 = 1 # datentyp
        order_item.c044 = order_kontonummer # kontonummer
        order_item.c045 = order_laufnummer # laufnummer
        order_item.c046 = 99 # vertreternummer
        order_item.c047 = nil # prodflag
        order_item.c048 = @mesonic_order.c027.year # lieferjahr
        order_item.c052 = 0 # stat. wert
        order_item.c054 = 0 # bewertungspreis editieren
#        order_item.c055 = cart_item.inventory.ChargeIdent # flag hauptartikel mit charge/identnummer
        order_item.c055 = cart_item.inventory.Auspraegungsflag
        order_item.c056 = @customer.account_number # interessentenkontonummer
        order_item.c057 = 0 # lagerbestand ändern J/N
        order_item.c058 = 0 # key für dispozeile
        order_item.c059 = 0 # zeilennummer d kundenauftrags
        order_item.c060 = 0 # temp gridzeilennumer
        order_item.c061 = 0 # zeilennummer des auftrages
        order_item.c062 = 0 # key handels stückliste
        order_item.c063 = 0 # flag für update ( telesales )
        order_item.c068 = 1 # lieferantenartikelnummer
        order_item.c070 = 0 # colli faktor
        order_item.c071 = 0 # umrechnungsfaktor colli
        order_item.c072 = 0 # umrechnungsfaktor menge 2
        order_item.c073 = 1 # preisartenflag
        order_item.c074 = 0 # flag für aufgeteilte hauptartikel
        order_item.c075 = 0 # flag v lieferantenlieferung aufteilen
        order_item.c077 = 0 # preisupdateflag
        order_item.c078 = index + 1 # zeilennummer (intern)
        order_item.c081 = 0 # nummer des kontraktpreises
        order_item.c082 = 0 # menge 2
        order_item.c083 = cart_item.inventory.Steuersatzzeile * 10
        order_item.c085 = 2 # exim durchgeführt änderungen
        order_item.c086 = 0 # EURO einstandspreis
        order_item.c087 = 0 # bnk-prozent
        order_item.c088 = 0 # ausgebuchte menge
        order_item.c091 = 0 # textkennzeichen artikel
        order_item.c092 = 0 # betrag bezugskosten
        order_item.c098 = 0 # flag reservierung
        order_item.c099 = 0 # rückstandsmenge
        order_item.c100 = 0
        order_item.c101 = 0
        order_item.c104 = 0
        order_item.mesocomp = @mesocomp
        order_item.mesoyear = @mesoyear
        order_item.mesoprim = "#{order_item.c000}-#{@mesocomp}-#{@mesoyear}"
        order_item.C106 = ""
        order_item.C107 = 0
        order_item.C108 = ""
        order_item.C109 = 0
      end
    }
  end

  def copy_opensteam_order_information!
    @mesonic_order.c004 = @opensteam_order.billing_name
    @mesonic_order.c005 = @opensteam_order.billing_to_hand
    @mesonic_order.c006 = @opensteam_order.billing_street
    @mesonic_order.c007 = @opensteam_order.billing_postal
    @mesonic_order.c008 = @opensteam_order.billing_city

    begin
      @mesonic_order.c081 = @opensteam_order.billing_name2
      @mesonic_order.c082 = @opensteam_order.shipping_name2
    rescue Exception
    end

    @mesonic_order.c010 = @opensteam_order.shipping_name
    @mesonic_order.c011 = @opensteam_order.shipping_to_hand
    @mesonic_order.c012 = @opensteam_order.shipping_street
    @mesonic_order.c013 = @opensteam_order.shipping_postal
    @mesonic_order.c014 = @opensteam_order.shipping_city
    @mesonic_order.c017 = @opensteam_order.billing_state_code
    @mesonic_order.c019 = @opensteam_order.shipping_state_code
    @mesonic_order.c097 = @opensteam_order.billing_method.to_i

    if @opensteam_order.billing_method.to_i == 1004
      @mesonic_order.c051 = mesonic_kontenstamm_fakt.c107
    else
      @mesonic_order.c051 = IvellioVellin::Order.payment_methods2[ :"#{@opensteam_order.billing_method}" ].try(:to_i)
    end

    @mesonic_order.c089 = @opensteam_order.shipping_method.to_i
  end
end