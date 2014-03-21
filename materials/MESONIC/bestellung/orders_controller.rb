class OrdersController < OpensteamController
  def place
    @order.customer = current_customer

    @mesonic_order_initializer = Mesonic::OrderInitializer.new( @order, @cart, current_customer, @order.order_number )
    @mesonic_order_initializer.initialize_mesonic_order!
    @mesonic_order_initializer.initialize_mesonic_order_items!

    respond_to do |format|
      if @mesonic_order_initializer.valid?  && @mesonic_order_initializer.save

        @account_number = current_customer.account_number
        @billing_number = @mesonic_order_initializer.mesonic_order.c021
        @order_number   = @mesonic_order_initializer.mesonic_order.c022

        @order.account_number = @account_number
        @order.billing_number = @billing_number
        @order.order_number   = @order_number

        @order.save

        Mailer::OrderMailer.deliver_order_confirmation( @order, @cart, current_customer, @order_number, @billing_number )

        clear_active_order
        clear_cart

        format.html { render :action => :finish }
      else
        flash[:error] = "An Error occured!"
        format.html { render :action => :error }
      end
    end
  end


  private

  def initialize_mesonic_order_items( order )
    returning( order ) do |o|

      order_kontonummer = o.C021
      order_primary_key = o.C000
      order_laufnummer  = o.C022

      @cart.items.each_with_index do |cart_item, index|
        order_item = IvellioVellin::OrderItem.new

        order_item.id = [ order_primary_key, "%06d" % index ].join("-")

        order_item.C003 = cart_item.inventory.article_number
        order_item.C004 = cart_item.inventory.name
        order_item.C005 = cart_item.menge # menge bestellt
        order_item.C006 = cart_item.menge # menge geliefert
        order_item.C007 = cart_item.einzelpreis # einzelpreis
        order_item.C008 = 0 # zeilenrabatt 1 und 2
        order_item.C009 = 4002 # erlöskonto
        order_item.C010 = cart_item.inventory.Steuersatzzeile # umsatzsteuer prozentsatz
        order_item.C011 = 1 # statistikkennzeichen
        order_item.C012 = cart_item.inventory.ArtGruppe # artikelgruppe
        order_item.C013 = 0 # liefertage
        order_item.C014 = cart_item.inventory.Provisionscode # provisionscode
        order_item.C015 = nil # colli
        order_item.C016 = 0 # menge bereits geliefert
        order_item.C018 = 0 # faktor 1 nach formeleingabe
        order_item.C019 = 0 # faktor 2 nach formeleingabe
        order_item.C020 = 0 # faktor 3 nach formeleingabe
        order_item.C021 = 0 # zeilenrabatt %1
        order_item.C022 = 0 # zeilenrabatt %2
        order_item.C023 = 0 # einstandspreis
        order_item.C024 = nil # umstatzsteuercode
        order_item.C025 = o.C027 # lieferdatum
        order_item.C026 = 400 # kostenstelle
        order_item.C027 = 0 # lieferwoche
        order_item.C031 = cart_item.gesamtwert # gesamtwert
        order_item.C032 = 0 # positionslevel
        order_item.C033 = nil # positionsnummer text
        order_item.C034 = cart_item.inventory.Gewicht # gewicht
        order_item.c035 = 0 # einstandspreis KZ
        order_item.c042 = 1 # datentyp
        order_item.c044 = order_kontonummer # kontonummer
        order_item.c045 = order_laufnummer # laufnummer
        order_item.C046 = 99 # vertreternummer
        order_item.C047 = nil # prodflag
        order_item.C048 = o.C027.year # lieferjahr
        order_item.C052 = 0 # stat. wert
        order_item.C054 = 0 # bewertungspreis editieren
        order_item.C055 = cart_item.inventory.ChargeIdent # flag hauptartikel mit charge/identnummer
        order_item.C056 = "1/00007" # statistikkontonummer
        order_item.C057 = 0 # lagerbestand ändern J/N
        order_item.C058 = 0 # key für dispozeile
        order_item.C059 = 0 # zeilennummer d kundenauftrags
        order_item.C060 = 0 # temp gridzeilennumer
        order_item.C061 = 0 # zeilennummer des auftrages
        order_item.C062 = 0 # key handels stückliste
        order_item.C063 = 0 # flag für update ( telesales )
        order_item.C068 = 1 # lieferantenartikelnummer
        order_item.C070 = 0 # colli faktor
        order_item.C071 = 0 # umrechnungsfaktor colli
        order_item.C072 = 0 # umrechnungsfaktor menge 2
        order_item.C073 = 1 # preisartenflag
        order_item.C074 = 0 # flag für aufgeteilte hauptartikel
        order_item.C075 = 0 # flag v lieferantenlieferung aufteilen
        order_item.C077 = 0 # preisupdateflag
        order_item.C078 = index # zeilennummer (intern)
        order_item.C081 = 0 # nummer des kontraktpreises
        order_item.C082 = 0 # menge 2
        order_item.C083 = cart_item.inventory.Steuersatzzeile * 10
        order_item.C085 = 2 # exim durchgeführt änderungen
        order_item.C086 = 0 # EURO einstandspreis
        order_item.C087 = 0 # bnk-prozent
        order_item.C088 = 0 # ausgebuchte menge
        order_item.C091 = 0 # textkennzeichen artikel
        order_item.C092 = 0 # betrag bezugskosten
        order_item.C098 = 0 # flag reservierung
        order_item.C099 = 0 # rückstandsmenge
      end
    end
  end

  def initialize_mesonic_order( order )
    current_date = Time.now

    returning( order ) do |o|
      o.agb = "1" #current_customer.agb? ? "1" : "0"

      o.C020 = current_customer.mesonic_account.account_number
      o.C021 = current_customer.kontonummer #      o.C021 = "09WEB" #account_number
      o.C022 = "#{current_date.strftime('%y%m%d%H%M%S')}#{current_date.usec}" # laufnummer
      o.id   = [ o.C021, o.C022 ].join("-") # primary key

      mesonic_kontenstamm = Mesonic::KontenstammFakt.by_kontonummer( o.C021 ).first

      o.C023 = "L" # druckstatus angebot
      o.C024 = "L" # druckstatus auftragsbestätigung
      o.C025 = "L" # durckstatus lieferschein
      o.C026 = "L" # druckstatus faktura
      o.C027 = current_date # datum angebot
      o.C030 = '1/00007' #### konto-lieferadresse, Wert "1/00007" immer gleich?
      o.C034 = '' #### tabelle t0357 fehlt !
      o.C035 = mesonic_kontenstamm.c077 # belegart
      o.C036 = mesonic_kontenstamm.c065 # vertreternummer
      o.C037 = 0 # nettotage (sql statement folgt ?? )
      o.C038 = 0 # skonto%1 (sql statement folgt ?? )
      o.C039 = 0 # skontotage1 (sql statement folgt ?? )
      o.C040 = 0 # summenrabatt (sql statement folgt ?? )
      o.C041 = 0 # fw-zeile (immer 0)
      o.C047 = mesonic_kontenstamm.c066  # preisliste
      o.C049 = 0 # fw einheit
      o.C050 = 0 # fw-faktor
      o.C051 = mesonic_kontenstamm.c107  # kondition1
      o.C053 = mesonic_kontenstamm.c122 # kostentraeger
      o.C054 = 400 # kostenstelle
      o.C056 = 0 # skonto%2 ( sql statement folgt ?? )
      o.C057 = 0 # skontotage2 ( sql statement folgt ?? )
      o.C059 = current_date # datum d. erstanlage
      o.C074 = 0 # kennzeichen f FW-Umrechung
      o.C075 = 0 # flag für Webinterface
      o.C076 = 0 # Dokumenten ID
      o.C077 = 0 # FW-Notierungsflag
      o.C078 = 0 # xml-erweiterung
      o.C080 = 0 # filler
      o.C086 = 0 # teilliefersperre
      o.C088 = 0 # priorität
      o.C089 = 1 # freier text 1
      o.C090 = 0 # freier text 2
      o.C091 = 0 # freier text 3
      o.C092 = 0 # freier text 4
      o.C093 = 0 # flag sammelrechnung
      o.C094 = 0 # flag methode
      o.C095 = 0 # ausprägung 1
      o.C096 = 0 # ausprägung 2
#      o.C097 = ## flag zahlungsart ### written by form
      o.C098 = 101 # flag freigabekontrolle angebot
      o.C099 = 0 # kumulierter zahlungsbetrag
      o.C100 = 0 # endbetrag
      o.C102 = 0 # rohertrag
      o.C103 = current_date + 3.days #
      o.C104 = 0 # ansprechpartner rechnungsadresse
      o.C105 = 0 # ansprechpartner lieferadresse
      o.C106 = 0 # fremdwährungskurs
      o.C109 = 0 # kontrakttyp
      o.C111 = 2 # exim durchgeführte änderungen
      o.C113 = o.C021 #  o.C113 = "09WEB" # konto rechnungsadresse
      o.C114 = 0 # anzahlungsbetrag
      o.C115 = 101 # flag freigabekontrolle auftrag
      o.C116 = 101 # flag freigabekontrolle lieferschein
      o.C117 = 101 # flag freigabekontrolle faktura
      o.C118 = 0 # euro rohertrag
      o.C120 = 0 # fw-einheit für storno
      o.C121 = 0 # sortierung
      o.C123 = 0 # textkennzeichen konto
      o.C126 = 0 # aktionsplanzeile
      o.C127 = 0 # karenztage
    end
  end
end